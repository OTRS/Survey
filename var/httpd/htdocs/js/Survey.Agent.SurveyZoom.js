// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Survey = Survey || {};
Survey.Agent = Survey.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Survey.Agent.SurveyZoom
 * @description
 *      This namespace contains the special module functions for SurveyZoom.
 */
Survey.Agent.SurveyZoom = (function (TargetNS) {
    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.contents().height();
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Survey.HTMLRichTextHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('Survey.HTMLRichTextHeightMax')) {
                    NewHeight = Core.Config.Get('Survey.HTMLRichTextHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    return TargetNS;
}(Survey.Agent.SurveyZoom || {}));
