# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_PublicSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Umfrage';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'}  = 'Frage';
    $Self->{Translation}->{'Finish'}    = 'Fertigstellen';
    $Self->{Translation}->{'Need to select question:'}  = 'Folgende Frage muss ausgefüllt werden:';
    $Self->{Translation}->{'finished'}  = 'fertiggestellt';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Dieser Umfrage-Schlüssel ist nicht (mehr) gültig!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Sie haben diese Umfrage abgeschlossen. Vielen Dank.';

    return 1;
}

1;
