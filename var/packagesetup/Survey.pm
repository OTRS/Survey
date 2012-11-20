# --
# Survey.pm - code to excecute during package installation
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Survey.pm,v 1.1.2.3 2012-11-20 12:52:10 jh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::Survey;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::SysConfig;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1.2.3 $) [1];

=head1 NAME

var::packagesetup::Survey - CodeInstall and CodeUpgrade for Survey

=head1 SYNOPSIS

Do Code Installs or Code Upgrades.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::XML;
    use var::packagesetup::Survey;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );
    my $CodeObject = var::packagesetup::Survey->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        XMLObject    => $XMLObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject EncodeObject MainObject TimeObject DBObject XMLObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;
    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgradeFromLowerThan_2_0_5()

This function is only executed if the installed module version is smaller than 2.0.5.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_0_5();

=cut

sub CodeUpgradeFromLowerThan_2_0_5 {
    my ( $Self, %Param ) = @_;

    # set all survey_question records
    # that don't have answer_required set to something
    # to 0
    $Self->_Prefill_AnswerRequiredFromSurveyQuestion_2_0_5();

    # add new system notifications that were added in version 2.0.3

    return 1;
}

=item _Prefill_AnswerRequiredFromSurveyQuestion_2_0_5()

Inserts 0 into all answer_required records of table suvey_question
where there is no entry present.

    my $Success = $PackageSetup->_Prefill_AnswerRequiredFromSurveyQuestion_2_0_5();

=cut

sub _Prefill_AnswerRequiredFromSurveyQuestion_2_0_5 {
    my ($Self) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, answer_required '
            . 'FROM survey_question',
        Limit => 0,
    );
    my @IdsToUpdate;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # if we had an id
        # but no answer_required or answer_required isn't 0 or 1
        # collect the ID in @IdsToUpdate
        if (
            defined $Row[0]
            && length $Row[0]
            && (
                !defined $Row[1]
                || ( $Row[1] ne '0' && $Row[1] ne '1' )
            )
            )
        {
            push @IdsToUpdate, $Row[0];
        }
    }

    for my $QuestionID (@IdsToUpdate) {
        $Self->{DBObject}->Do(
            SQL =>
                'UPDATE survey_question SET answer_required = 0 WHERE id = ?',
            Bind => [
                \$QuestionID,
            ],
        );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1.2.3 $ $Date: 2012-11-20 12:52:10 $

=cut
