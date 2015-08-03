# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Survey::TriggerSendRequests;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Time',
    'Kernel::System::Survey',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Trigger sending delayed survey requests');
    $Self->AddOption(
        Name        => 'type',
        Description => "Specify dry or real triggering (see help for more info)",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/(real|dry)/smx,
    );

    $Self->AdditionalHelp(
        "<yellow>
                Configuration is done using SysConfig (Survey->Core)
                Short explanation:
                    1. Go to your SysConfig and
                       - configure, Survey::SendInHoursAfterClose to a higher value than 0
                    2. Create a survey, make it master
                    3. Create a ticket, close it
                    4. Wait the necessary amount of hours you've configured
                    5. You can do a dry run to get a list of surveys that would be sent ( --type dry )
                    6. If you're fine with it, activate daemon task in Daemon::SchedulerCronTaskManager::Task
        </yellow>\n"
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SendInHoursAfterClose = $Kernel::OM->Get('Kernel::Config')->Get('Survey::SendInHoursAfterClose');
    if ( !$SendInHoursAfterClose ) {
        die "No days configured in Survey::SendInHoursAfterClose.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trigger survey requests</yellow>\n");

    # get type option
    my $Type = $Self->GetOption('type');
    ( $Type eq 'real' )
        ? $Self->Print("<yellow>Real triggering...</yellow>\n")
        : $Self->Print("<yellow>Dry triggering...</yellow>\n");

    $Self->Print( "\n<green>" . ( '=' x 69 ) . "</green>\n" );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # find survey_requests that haven't been sent yet
    my $Success = $DBObject->Prepare(
        SQL => '
            SELECT id, ticket_id, create_time, public_survey_key
            FROM survey_request
            WHERE send_time IS NULL
            ORDER BY create_time DESC',
    );

    if ( !$Success ) {
        $Self->PrintError("DB error during a Prepare function.\n");
        return $Self->ExitCodeError();
    }

    # fetch the result
    my @Rows;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Rows, {
            ID              => $Row[0],
            TicketID        => $Row[1],
            CreateTime      => $Row[2],
            PublicSurveyKey => $Row[3],
        };
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get SystemTime in UnixTime
    my $Now = $TimeObject->SystemTime();

    SURVEYREQUEST:
    for my $Line (@Rows) {

        for my $Val (qw(ID TicketID CreateTime)) {
            if ( !$Line->{$Val} ) {
                $Self->PrintError("$Val missing in service_request row.\n");
                next SURVEYREQUEST;
            }
        }

        # convert create_time to unixtime
        my $CreateTime = $TimeObject->TimeStamp2SystemTime(
            String => $Line->{CreateTime},
        );

        my $SendInHoursAfterClose = $Kernel::OM->Get('Kernel::Config')->Get('Survey::SendInHoursAfterClose');

        # don't send for survey_requests that are younger than CreateTime + $SendINHoursAfterClose
        if ( $SendInHoursAfterClose * 3600 + $CreateTime > $Now ) {
            $Self->Print(
                "<yellow>Did not send for survey_request with id $Line->{ID} because send time wasn't reached yet.</yellow>\n"
            );
            next SURVEYREQUEST;
        }

        $Self->Print(
            "<yellow>Sending survey for survey_request with id $Line->{ID} that belongs to TicketID $Line->{TicketID}.</yellow>\n"
        );

        if ( $Type eq 'real' && $Line->{ID} && $Line->{TicketID} ) {
            my $Success = $Kernel::OM->Get('Kernel::System::Survey')->RequestSend(
                TriggerSendRequests => 1,
                SurveyRequestID     => $Line->{ID},
                TicketID            => $Line->{TicketID},
                PublicSurveyKey     => $Line->{PublicSurveyKey},
            );
            $Self->Print("<green>Request is sent.</green>\n") if $Success;
        }
    }

    $Self->Print("\n<green>Done.</green>\n");
    $Self->Print( "\n<green>" . ( '=' x 69 ) . "</green>\n" );
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
