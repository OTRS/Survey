# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_PublicSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Анкета';
    $Self->{Translation}->{'Questions'} = 'Въпроси';
    $Self->{Translation}->{'Question'}  = 'Въпрос';
    $Self->{Translation}->{'Finish'}    = 'Завърши';
    $Self->{Translation}->{'finished'}  = 'завършено';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Този ключ е невалиден за проучването!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Благодарим ви за обратната информация';
    $Self->{Translation}->{'Need to select question:'}  = '';

    return 1;
}

1;
