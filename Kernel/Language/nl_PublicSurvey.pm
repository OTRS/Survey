# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_PublicSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Enquête';
    $Self->{Translation}->{'Questions'} = 'Vragen';
    $Self->{Translation}->{'Question'}  = 'Vraag';
    $Self->{Translation}->{'Finish'}    = 'Voltooien';
    $Self->{Translation}->{'finished'}  = 'voltooid';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Deze enquête is ongeldig.';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Bedankt voor uw tijd.';
    $Self->{Translation}->{'Need to select question:'}  = 'Selecteer eerst een vraag:';

    return 1;
}

1;
