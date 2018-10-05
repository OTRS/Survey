# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Create test survey.
        my $SurveyTitle         = 'Survey ' . $Helper->GetRandomID();
        my $Introduction        = 'Survey Introduction';
        my $Description         = 'Survey Description';
        my $NotificationSender  = 'quality@example.com';
        my $NotificationSubject = 'Survey Notification Subject';
        my $NotificationBody    = 'Survey Notification Body';

        my $SurveyID = $Kernel::OM->Get('Kernel::System::Survey')->SurveyAdd(
            UserID              => 1,
            Title               => $SurveyTitle,
            Introduction        => $Introduction,
            Description         => $Description,
            NotificationSender  => $NotificationSender,
            NotificationSubject => $NotificationSubject,
            NotificationBody    => $NotificationBody,
            Queues              => [2],
        );
        $Self->True(
            $SurveyID,
            "Survey ID $SurveyID is created",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentSurveyZoom of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyZoom;SurveyID=$SurveyID");

        # Click on 'Edit General Info' and switch screen.
        $Selenium->find_element( "#Menu010-EditGeneralInfo", 'css' )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length;' );

        my @Test = (
            {
                ID     => 'Title',
                Stored => $SurveyTitle,
                Edited => $SurveyTitle . ' edited',
            },
            {
                ID     => 'Introduction',
                Stored => $Introduction,
                Edited => $Introduction . ' edited',
            },
            {
                ID     => 'Description',
                Stored => $Description,
                Edited => $Description . ' edited',
            },
            {
                ID     => 'NotificationSender',
                Stored => $NotificationSender,
                Edited => $NotificationSender . ' edited',
            },
            {
                ID     => 'NotificationSubject',
                Stored => $NotificationSubject,
                Edited => $NotificationSubject . ' edited',
            },
            {
                ID     => 'NotificationBody',
                Stored => $NotificationBody,
                Edited => $NotificationBody . ' edited',
            },
        );

        # Check test survey values and edit them.
        for my $SurveyStored (@Test) {

            $Self->Is(
                $Selenium->find_element( "#$SurveyStored->{ID}", 'css' )->get_value(),
                $SurveyStored->{Stored},
                "#$SurveyStored->{ID} stored value",
            );

            # Edit value.
            $Selenium->find_element( "#$SurveyStored->{ID}", 'css' )->send_keys(' edited');
        }

        # Submit updates and switch back window.
        $Selenium->find_element("//button[\@value='Update'][\@type='submit']")->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Menu010-EditGeneralInfo").length;' );
        sleep 2;

        # Click on 'Edit General Info' again and switch window.
        $Selenium->find_element( "#Menu010-EditGeneralInfo", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length;' );

        # Check edited values
        for my $SurveryEdited (@Test) {

            $Self->Is(
                $Selenium->find_element( "#$SurveryEdited->{ID}", 'css' )->get_value(),
                $SurveryEdited->{Edited},
                "#$SurveryEdited->{ID} stored value",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Clean-up test created survey data.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_queue WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle is deleted",
        );

        # Delete test created survey.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey WHERE id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "$SurveyTitle is deleted",
        );
    }
);

1;
