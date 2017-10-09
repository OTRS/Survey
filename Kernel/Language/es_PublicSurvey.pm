# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_PublicSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Encuesta';
    $Self->{Translation}->{'Questions'} = 'Preguntas';
    $Self->{Translation}->{'Question'}  = 'Pregunta';
    $Self->{Translation}->{'Finish'}    = 'Terminar';
    $Self->{Translation}->{'Need to select question:'}  = 'Necesita seleccionar una pregunta:';
    $Self->{Translation}->{'finished'}  = 'Terminado';
    $Self->{Translation}->{'This Survey-Key is invalid!'} = 'El código de esta encuesta es inválido!';
    $Self->{Translation}->{'Thank you for your feedback.'}= 'Gracias por su retroalimentación.';

    return 1;
}

1;
