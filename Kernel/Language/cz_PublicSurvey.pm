# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz_PublicSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'}    = 'Průzkum';
    $Self->{Translation}->{'Questions'} = 'Dotazy';
    $Self->{Translation}->{'Question'}  = 'Dotaz';
    $Self->{Translation}->{'Finish'}    = 'Ukončit';
    $Self->{Translation}->{'finished'}  = 'ukončeno';
    $Self->{Translation}->{'This Survey-Key is invalid!'}
        = 'Tento klíč je nevhodný pro průzkum!';
    $Self->{Translation}->{'Thank you for your feedback.'}
        = 'Děkujeme Vám za zpětnou vazbu';
    $Self->{Translation}->{'Need to select question:'}  = 'Nutno vybrat dotaz:';

    return 1;
}

1;
