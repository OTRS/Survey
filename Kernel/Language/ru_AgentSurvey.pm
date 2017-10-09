# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_AgentSurvey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Introduction'} = 'Вступление';
    $Self->{Translation}->{'Internal'} = 'Внутреннее';
    $Self->{Translation}->{'Change Status'} = 'Изменить статус';
    $Self->{Translation}->{'Sent requests'} = 'Отправлено запросов';
    $Self->{Translation}->{'Received surveys'} = 'Получено ответов';
    $Self->{Translation}->{'Send Time'} = 'Время отправки';
    $Self->{Translation}->{'Vote Time'} = 'Время ответа';
    $Self->{Translation}->{'Details'} = 'Подробно';
    $Self->{Translation}->{'New'} = 'Новый';
    $Self->{Translation}->{'Master'} = 'Основной';
    $Self->{Translation}->{'Valid'} = 'Действительный';
    $Self->{Translation}->{'Invalid'} = 'Не действительный';
    $Self->{Translation}->{'answered'} = 'ответили';
    $Self->{Translation}->{'not answered'} = 'не ответили';

    return 1;
}

1;
