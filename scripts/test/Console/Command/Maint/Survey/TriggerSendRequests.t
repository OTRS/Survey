# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Survey::TriggerSendRequests');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Survey::TriggerSendRequests - No options",
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# set sysconfig 'SendInHoursAfterClose' on 1
$ConfigObject->Set(
    Valid => 1,
    Key   => 'Survey::SendInHoursAfterClose',
    Value => 1,
);

# check command with options 'real' and 'dry'
for my $Type (qw(real dry)) {

    $ExitCode = $CommandObject->Execute( '--type', $Type );
    $Self->Is(
        $ExitCode,
        0,
        "Option '$Type'",
    );
}

# check command with invalid option
$ExitCode = $CommandObject->Execute( '--type', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Option '$RandomName'",
);

# set sysconfig 'SendInHoursAfterClose' on 0
$ConfigObject->Set(
    Valid => 1,
    Key   => 'Survey::SendInHoursAfterClose',
    Value => 0,
);

# check command with options 'real' and 'dry'
for my $Type (qw(real dry)) {

    $ExitCode = $CommandObject->Execute( '--type', $Type );
    $Self->Is(
        $ExitCode,
        1,
        "Option '$Type', sysconfig 'SendInHoursAfterClose' disabled",
    );
}

1;
