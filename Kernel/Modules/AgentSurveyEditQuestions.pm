# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyEditQuestions;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get needed objects
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # question add
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'QuestionAdd' ) {
        my $SurveyID = $ParamObject->GetParam( Param => "SurveyID" );
        my $Question = $ParamObject->GetParam( Param => "Question" );
        my $Type     = $ParamObject->GetParam( Param => "Type" );

        my $AnswerRequired = $ParamObject->GetParam( Param => 'AnswerRequired' );
        if ( $AnswerRequired && $AnswerRequired eq 'No' ) {
            $AnswerRequired = 0;
        }
        else {
            $AnswerRequired = 1;
        }

        # check if survey exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Question) {
            $SurveyObject->QuestionAdd(
                SurveyID       => $SurveyID,
                Question       => $Question,
                Type           => $Type,
                AnswerRequired => $AnswerRequired,
                UserID         => $Self->{UserID},
            );
            $SurveyObject->QuestionSort( SurveyID => $SurveyID );
        }
        else {
            $ServerError{Question} = 1;
        }

        return $Self->_MaskQuestionOverview(
            SurveyID    => $SurveyID,
            ServerError => \%ServerError,
        );
    }

    # ------------------------------------------------------------ #
    # question delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDelete' ) {
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->QuestionDelete(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
        $SurveyObject->QuestionSort( SurveyID => $SurveyID );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question up
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionUp' ) {
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->QuestionSort( SurveyID => $SurveyID );
        $SurveyObject->QuestionUp(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question down
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionDown' ) {
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->QuestionSort( SurveyID => $SurveyID );
        $SurveyObject->QuestionDown(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=SurveyEdit;SurveyID=$SurveyID#Question"
        );
    }

    # ------------------------------------------------------------ #
    # question edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionEdit' ) {
        my $SurveyID   = $ParamObject->GetParam( Param => 'SurveyID' );
        my $QuestionID = $ParamObject->GetParam( Param => 'QuestionID' );

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {
            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        return $Self->_MaskQuestionEdit(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
        );
    }

    # ------------------------------------------------------------ #
    # question save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'QuestionSave' ) {
        my $QuestionID = $ParamObject->GetParam( Param => 'QuestionID' );
        my $SurveyID   = $ParamObject->GetParam( Param => 'SurveyID' );
        my $Question   = $ParamObject->GetParam( Param => 'Question' );

        my $AnswerRequired = $ParamObject->GetParam( Param => 'AnswerRequired' );
        if ( $AnswerRequired && $AnswerRequired eq 'No' ) {
            $AnswerRequired = 0;
        }
        else {
            $AnswerRequired = 1;
        }

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Question) {
            $SurveyObject->QuestionUpdate(
                QuestionID     => $QuestionID,
                SurveyID       => $SurveyID,
                Question       => $Question,
                AnswerRequired => $AnswerRequired,
                UserID         => $Self->{UserID},
            );

            return $Self->_MaskQuestionEdit(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
            );
        }
        else {
            $ServerError{QuestionServerError} = 'ServerError';
        }

        return $Self->_MaskQuestionEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            ServerError => \%ServerError,
        );
    }

    # ------------------------------------------------------------ #
    # answer add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerAdd' ) {
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $Answer     = $ParamObject->GetParam( Param => "Answer" );

        # check if survey and question exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey or question!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Answer) {
            $SurveyObject->AnswerAdd(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
                Answer     => $Answer,
                UserID     => $Self->{UserID},
            );

            return $Self->_MaskQuestionEdit(
                SurveyID   => $SurveyID,
                QuestionID => $QuestionID,
            );
        }
        else {
            $ServerError{AnswerServerError} = 'ServerError';
        }

        return $Self->_MaskQuestionEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            ServerError => \%ServerError,
        );
    }

    # ------------------------------------------------------------ #
    # answer delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerDelete' ) {
        my $AnswerID   = $ParamObject->GetParam( Param => "AnswerID" );
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $AnswerID,
                Element   => 'Answer'
            )
            ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->AnswerDelete(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
        $SurveyObject->AnswerSort( QuestionID => $QuestionID );

        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer up
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerUp' ) {
        my $AnswerID   = $ParamObject->GetParam( Param => "AnswerID" );
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $AnswerID,
                Element   => 'Answer'
            )
            ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->AnswerSort( QuestionID => $QuestionID );
        $SurveyObject->AnswerUp(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );

        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer down
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerDown' ) {
        my $AnswerID   = $ParamObject->GetParam( Param => "AnswerID" );
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );

        # check if survey, question and answer exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $AnswerID,
                Element   => 'Answer'
            )
            ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }
        $SurveyObject->AnswerSort( QuestionID => $QuestionID );
        $SurveyObject->AnswerDown(
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );

        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer",
        );
    }

    # ------------------------------------------------------------ #
    # answer edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerEdit' ) {
        my $SurveyID   = $ParamObject->GetParam( Param => 'SurveyID' );
        my $QuestionID = $ParamObject->GetParam( Param => 'QuestionID' );
        my $AnswerID   = $ParamObject->GetParam( Param => 'AnswerID' );

        # check if survey, question and answer exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $AnswerID,
                Element   => 'Answer'
            )
            ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }

        return $Self->_MaskAnswerEdit(
            SurveyID   => $SurveyID,
            QuestionID => $QuestionID,
            AnswerID   => $AnswerID,
        );
    }

    # ------------------------------------------------------------ #
    # answer save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AnswerSave' ) {
        my $AnswerID   = $ParamObject->GetParam( Param => "AnswerID" );
        my $QuestionID = $ParamObject->GetParam( Param => "QuestionID" );
        my $SurveyID   = $ParamObject->GetParam( Param => "SurveyID" );
        my $Answer     = $ParamObject->GetParam( Param => "Answer" );

        # check if survey, question and answer exists
        if (
            $SurveyObject->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $QuestionID,
                Element   => 'Question'
            ) ne 'Yes'
            || $SurveyObject->ElementExists(
                ElementID => $AnswerID,
                Element   => 'Answer'
            )
            ne 'Yes'
            )
        {

            return $LayoutObject->NoPermission(
                Message    => 'You have no permission for this survey, question or answer!',
                WithHeader => 'yes',
            );
        }

        my %ServerError;
        if ($Answer) {
            $SurveyObject->AnswerUpdate(
                AnswerID   => $AnswerID,
                QuestionID => $QuestionID,
                Answer     => $Answer,
                UserID     => $Self->{UserID},
            );

            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=QuestionEdit;SurveyID=$SurveyID;QuestionID=$QuestionID#Answer"
            );
        }
        else {
            $ServerError{AnswerServerError} = 'SeverError';
        }

        return $Self->_MaskAnswerEdit(
            SurveyID    => $SurveyID,
            QuestionID  => $QuestionID,
            AnswerID    => $AnswerID,
            ServerError => \%ServerError,
        );
    }

    # ------------------------------------------------------------ #
    # question overview
    # ------------------------------------------------------------ #
    my $SurveyID = $ParamObject->GetParam( Param => 'SurveyID' );

    if ( !$SurveyID ) {

        return $LayoutObject->ErrorScreen(
            Message => 'No SurveyID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check if survey exists
    if (
        $SurveyObject->ElementExists(
            ElementID => $SurveyID,
            Element   => 'Survey'
        ) ne
        'Yes'
        )
    {

        return $LayoutObject->NoPermission(
            Message    => 'You have no permission for this survey!',
            WithHeader => 'yes',
        );
    }

    return $Self->_MaskQuestionOverview( SurveyID => $SurveyID );
}

sub _MaskQuestionOverview {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $Output;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Param{SurveyID} ) {

        return $LayoutObject->ErrorScreen(
            Message => 'No SurveyID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # output header
    $Output = $LayoutObject->Header(
        Title     => 'Survey Edit Questions',
        Type      => 'Small',
        BodyClass => 'Popup',
    );

    # get survey object
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    # get all attributes of the survey
    my %Survey = $SurveyObject->SurveyGet( SurveyID => $Param{SurveyID} );

    $LayoutObject->Block(
        Name => 'SurveyEditQuestions',
        Data => \%Survey,
    );

    my @List = $SurveyObject->QuestionList( SurveyID => $Param{SurveyID} );

    if ( $Survey{Status} && $Survey{Status} eq 'New' ) {

        my $ArrayHashRef = [
            {
                Key      => 'YesNo',
                Value    => 'YesNo',
                Selected => 1,
            },
            {
                Key   => 'Radio',
                Value => 'Radio (List)',
            },
            {
                Key   => 'Checkbox',
                Value => 'Checkbox (List)',
            },
            {
                Key   => 'Textarea',
                Value => 'Textarea',
            },
        ];

        my $SelectionType = $LayoutObject->BuildSelection(
            Data          => $ArrayHashRef,
            Name          => 'Type',
            ID            => 'Type',
            SelectedValue => 'Yes/No',
            Translation   => 1,
            Title         => $LayoutObject->{LanguageObject}->Translate('Question Type'),
        );

        $ArrayHashRef = [
            {
                Key      => 'Yes',
                Value    => 'Yes',
                Selected => 1,
            },
            {
                Key   => 'No',
                Value => 'No',
            }
        ];

        my $AnswerRequiredSelect = $LayoutObject->BuildSelection(
            Data          => $ArrayHashRef,
            Name          => 'AnswerRequired',
            ID            => 'AnswerRequired',
            SelectedValue => 'Yes',
            Translation   => 1,
        );

        my $QuestionErrorClass = '';
        if ( $ServerError{Question} ) {
            $QuestionErrorClass = 'ServerError';
        }

        $LayoutObject->Block(
            Name => 'SurveyAddQuestion',
            Data => {
                SurveyID             => $Param{SurveyID},
                SelectionType        => $SelectionType,
                AnswerRequiredSelect => $AnswerRequiredSelect,
                QuestionErrorClass   => $QuestionErrorClass,
            },
        );

        if ( scalar @List ) {
            $LayoutObject->Block(
                Name => 'SurveyQuestionsTable',
                Data => {},
            );
            $LayoutObject->Block(
                Name => 'SurveyStatusColumn',
                Data => {},
            );

            $LayoutObject->Block(
                Name => 'SurveyDeleteColumn',
                Data => {},
            );

            my $Counter = 0;

            for my $Question (@List) {
                my $AnswerCount = $SurveyObject->AnswerCount(
                    QuestionID => $Question->{QuestionID},
                );

                my $Class;
                my $ClassUp;
                my $ClassDown;

                if ( !$Counter ) {
                    $ClassUp = 'Disabled';
                }

                if ( $Counter == $#List ) {
                    $ClassDown = 'Disabled';
                }

                my $Status = 'Complete';
                if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                    if ( $AnswerCount < 2 ) {
                        $Class  = 'Warning';
                        $Status = 'Incomplete';
                    }
                }

                my $AnswerRequired = $Question->{AnswerRequired} ? 'Yes' : 'No';

                $LayoutObject->Block(
                    Name => 'SurveyQuestionsRow',
                    Data => {
                        %{$Question},
                        Status         => $Status,
                        AnswerRequired => $AnswerRequired,
                        Class          => $Class,
                        ClassUp        => $ClassUp,
                        ClassDown      => $ClassDown,
                    },
                );
                $LayoutObject->Block(
                    Name => 'SurveyQuestionsDeleteButton',
                    Data => $Question,
                );
                $Counter++;
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'SurveyNoQuestionsSaved',
                Data => {
                    Columns => 5,
                    }
            );
        }

    }
    else {
        $LayoutObject->Block(
            Name => 'SurveyQuestionsTable',
            Data => {},
        );
        my $Counter;
        for my $Question (@List) {

            my $ClassUp;
            my $ClassDown;

            if ( !$Counter ) {
                $ClassUp = 'Disabled';
            }

            if ( $Counter && $Counter == $#List ) {
                $ClassDown = 'Disabled';
            }

            my $AnswerRequired = $Question->{AnswerRequired} ? 'Yes' : 'No';

            $LayoutObject->Block(
                Name => 'SurveyQuestionsSaved',
                Data => {
                    %{$Question},
                    AnswerRequired => $AnswerRequired,
                    ClassUp        => $ClassUp,
                    ClassDown      => $ClassDown,
                },
            );

            $Counter++;
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data         => { SurveyID => $Param{SurveyID} },
    );

    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

sub _MaskQuestionEdit {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $Output;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output header
    $Output = $LayoutObject->Header(
        Title     => 'Question Edit',
        Type      => 'Small',
        BodyClass => 'Popup',
    );

    # get survey object
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    my %Survey = $SurveyObject->SurveyGet( SurveyID => $Param{SurveyID} );
    my %Question = $SurveyObject->QuestionGet( QuestionID => $Param{QuestionID} );

    my $ArrayHashRef = [
        {
            Key   => 'Yes',
            Value => 'Yes',
        },
        {
            Key   => 'No',
            Value => 'No',
        }
    ];

    if ( $Question{AnswerRequired} ) {
        $ArrayHashRef->[0]{Selected} = 1;
    }
    else {
        $ArrayHashRef->[1]{Selected} = 1;
    }

    my $AnswerRequiredSelect = $LayoutObject->BuildSelection(
        Data          => $ArrayHashRef,
        Name          => 'AnswerRequired',
        ID            => 'AnswerRequired',
        SelectedValue => 'Yes',
        Translation   => 1,
    );

    # print the main body
    $LayoutObject->Block(
        Name => 'QuestionEdit',
        Data => {
            AnswerRequiredSelect => $AnswerRequiredSelect,
            %Question,
            %ServerError,
        },
    );

    if ( $Question{Type} eq 'YesNo' ) {
        $LayoutObject->Block( Name => 'QuestionEditTable' );
        $LayoutObject->Block( Name => 'QuestionEditYesno' );
    }
    elsif ( $Question{Type} eq 'Radio' || $Question{Type} eq 'Checkbox' ) {

        my $Type = $Question{Type};
        my @List = $SurveyObject->AnswerList( QuestionID => $Param{QuestionID} );
        if ( scalar @List ) {

            $LayoutObject->Block( Name => 'QuestionEditTable' );
            if ( $Survey{Status} eq 'New' ) {

                $LayoutObject->Block( Name => 'QuestionEditTableDelete' );

                my $Counter = 0;
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $Param{SurveyID};

                    my $ClassUp;
                    my $ClassDown;

                    # disable up action on first row
                    if ( !$Counter ) {
                        $ClassUp = 'Disabled';
                    }

                    # disable down action on last row
                    if ( $Counter == $#List ) {
                        $ClassDown = 'Disabled';
                    }

                    $LayoutObject->Block(
                        Name => "QuestionEdit" . $Type,
                        Data => {
                            %{$Answer2},
                            ClassUp   => $ClassUp,
                            ClassDown => $ClassDown,
                        },
                    );
                    $LayoutObject->Block(
                        Name => 'QuestionEdit' . $Type . 'Delete',
                        Data => $Answer2,
                    );
                    $Counter++;
                }

                $LayoutObject->Block(
                    Name => 'QuestionEditAddAnswer',
                    Data => {
                        %Question,
                        %ServerError,
                    },
                );
            }
            else {
                my $Counter;
                for my $Answer2 (@List) {
                    $Answer2->{SurveyID} = $Param{SurveyID};

                    my $ClassUp;
                    my $ClassDown;

                    if ( !$Counter ) {
                        $ClassUp = 'Disabled';
                    }

                    if ( $Counter && $Counter == $#List ) {
                        $ClassDown = 'Disabled';
                    }

                    $LayoutObject->Block(
                        Name => "QuestionEdit" . $Type,
                        Data => {
                            %{$Answer2},
                            ClassUp   => $ClassUp,
                            ClassDown => $ClassDown,
                        },
                    );
                    $Counter++;
                }
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'NoAnswersSaved',
                Data => {
                    Columns => 3,
                },
            );
            $LayoutObject->Block(
                Name => 'QuestionEditAddAnswer',
                Data => {%Question},
            );
        }
    }
    elsif ( $Question{Type} eq 'Textarea' ) {
        $LayoutObject->Block( Name => 'QuestionEditTextArea' );
    }
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data         => {%Param},
    );
    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

sub _MaskAnswerEdit {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output;
    $Output = $LayoutObject->Header(
        Title     => 'Answer Edit',
        Type      => 'Small',
        BodyClass => 'Popup',
    );
    my %Answer = $Kernel::OM->Get('Kernel::System::Survey')->AnswerGet( AnswerID => $Param{AnswerID} );
    $Answer{SurveyID} = $Param{SurveyID};

    # print the main table.
    $LayoutObject->Block(
        Name => 'AnswerEdit',
        Data => {
            %Answer,
            %Param,
            %ServerError,
        },
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentSurveyEditQuestions',
        Data         => {%Param},
    );

    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

1;
