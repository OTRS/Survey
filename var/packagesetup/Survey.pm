# --
# Survey.pm - code to execute during package installation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::Survey;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::SysConfig',
);

=head1 NAME

Survey.pm - code to execute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::Survey');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # rebuild ZZZ* files
    $Kernel::OM->Get('Kernel::System::SysConfig')->WriteDefault();

    # define the ZZZ files
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {

        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            next PREFIX if !-f $File;
            do $File;
            last PREFIX;
        }
    }

    # always discard the config object before package code is executed,
    # to make sure that the config object will be created newly, so that it
    # will use the recently written new config from the package
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Config'],
    );

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

=item CodeUpgradeFromLowerThan_2_0_92()

This function is only executed if the installed module version is smaller than 2.0.92.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_0_92();

=cut

sub CodeUpgradeFromLowerThan_2_0_92 {    ## no critic
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SELECT all functionality values
    $DBObject->Prepare(
        SQL => 'SELECT id, send_time FROM survey_request',
    );

    my @List;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        next ROW if !$Row[1];

        push @List, \@Row;
    }

    # save entries in new table
    for my $Entry (@List) {
        $DBObject->Do(
            SQL =>
                'UPDATE survey_request SET create_time = ? WHERE  id = ?',
            Bind => [ \$Entry->[1], \$Entry->[0] ],
        );
    }

    return 1;
}

=item CodeUpgradeFromLowerThan_2_1_5()

This function is only executed if the installed module version is smaller than 2.1.5.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_1_5();

=cut

sub CodeUpgradeFromLowerThan_2_1_5 {    ## no critic
    my ( $Self, %Param ) = @_;

    # set all survey_question records
    # that don't have answer_required set to something
    # to 0
    $Self->_Prefill_AnswerRequiredFromSurveyQuestion_2_1_5();

    return 1;
}

=item _Prefill_AnswerRequiredFromSurveyQuestion_2_1_5()

Inserts 0 into all answer_required records of table suvey_question
where there is no entry present.

    my $Success = $PackageSetup->_Prefill_AnswerRequiredFromSurveyQuestion_2_1_5();

=cut

sub _Prefill_AnswerRequiredFromSurveyQuestion_2_1_5 {    ## no critic
    my ($Self) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, answer_required '
            . 'FROM survey_question',
        Limit => 0,
    );
    my @IdsToUpdate;
    while ( my @Row = $DBObject->FetchrowArray() ) {

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
        $DBObject->Do(
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
