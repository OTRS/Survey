#5.0.2 2015-??-??
 - 2016-08-01 Calls to old Get() method replaced with calls to new Translate() method.
 - 2016-07-22 Fixed bug#[12184](http://bugs.otrs.org/show_bug.cgi?id=12184) - Survey Blacklist not working as expected.

#5.0.1 2015-10-20
 - 2015-10-13 Updated translations, thanks to all translators
 - 2015-10-06 Added French language, thanks to the translation team.
 - 2015-10-06 Added Galician language, thanks to the translation team.
 - 2015-10-06 Added Hungarian language, thanks to the translation team.
 - 2015-10-06 Added Vietnamese language, thanks to the translation team.

#5.0.0.beta1 2015-09-01
 - 2015-08-26 Initial version for OTRS 5
 - 2015-08-03 Added breadcrumbs to question and answer edit screens.
 - 2015-08-03 Updated look and feel of select controls.

#4.0.1 - 2014-11-25
 - 2014-11-21 Added code to migrate DTL code in SysConfig settings to TT during package update.
 - 2014-11-20 Added Serbian Cyrillic language
 - 2014-11-20 Added Swahili language

#4.0.0.rc1 - 2014-11-18
 - 2014-11-12 Sync translation files.
 - 2014-11-11 Code cleanup.
 - 2014-10-10 Added basic ticket information to public survey screen.

#4.0.0.beta1 - 2014-10-07
 - 2014-09-26 Added Spanish (Mexico) translation.
 - 2014-01-10 Improved brazilian portuguese translation, thanks to Murilo Moreira de Oliveira.
 - 2014-01-13 Added taiwanese chinese translation, thanks to Anson Chow.
 - 2014-02-07 Added russian translation, thanks to Andrey N. Burdin.

#2.3.2 - 2013-12-03
 - 2013-11-22 Added new functionality to add ticket types and services as send conditions for the survey.

#2.3.1 - 2013-11-12
 - 2013-11-07 Added Simplified Chinese translation thanx to Michael Shi!
 - 2013-11-06 Fixed bug#[9757](http://bugs.otrs.org/show_bug.cgi?id=9757) - Back buttons should to lead to last used screen and not browser history back.
 - 2013-11-06 Made survey zoom menu flexible (by SysConfig settings)
 - 2013-11-06 Improved Survey Overview visuals
 - 2013-11-06 Added Answer Required column to questions overview.

#2.3.0.beta1 - 2013-09-24
 - 2013-09-23 Initial release for OTRS 3.3.x series.
 - 2013-09-23 Changed API:
     SurveyNew()       => SurveyAdd()
     SurveySave()      => SurveyUpdate()
     SurveyQueueSave() => SurveyQueueSet()
     AnswerSave        => AnswerUpdate()
     PublicAnswerSave  => PublicAnswerSet()
     CountRequest      => RequestCount()
     CountVote         => VoteCount()
 - 2013-09-23 Split Frontend module AgentSurvey.pm
 - 2013-09-23 Improved error screens
 - 2013-09-22 Improved graphical columns usability
 - 2013-06-26 Extended unittests to check for Survey link mangling during sending process.
 - 2013-06-24 Fixed bug#[9544](http://bugs.otrs.org/show_bug.cgi?id=9544) thanx to Daniel Santos!
 - 2013-04-15 Added Malaysia translation, thanks to Kenny Cheah.
 - 2013-06-11 Added Japanese translation, thanks to Norihiro Tanaka.

#2.2.2 - 2013-01-31
 - 2013-01-31 Added Finish translation, thanks to Niklas Lampén.

#2.2.1 - 2013-01-25
 - 2013-01-24 First stable release for OTRS 3.2.x series.

#2.1.0.beta3 - 2013-01-18
 - 2013-01-16 Release candidate 1.

#2.1.0.beta2 - 2013-01-04
 - 2013-01-03 Code cleanup.

#2.1.0.beta1 - 2012-11-27
 - 2012-11-27 Init release for OTRS 3.2.
 - 2012-11-27 Fixed bug#[8940](http://bugs.otrs.org/show_bug.cgi?id=8940) thanx to Shawn!

#2.1.5 - 2012-11-27
 - 2012-11-20 Added possibility to require answers on survey questions.

#2.1.4 - 2012-09-18
 - 2012-10-17 Updated Polish translation, thanks to Pawel @ IB!

#2.1.3 - 2012-03-23
 - 2012-02-23 Added Portugal Portuguese translation, thanks to Rui Francisco!

#2.1.2 - 2012-02-22
 - 2012-02-22 Fixed bug#[8238](http://bugs.otrs.org/show_bug.cgi?id=8238) - Unable to enter questions in Survey.
 - 2012-02-15 Added Brazilian Portuguese translation, thanks to Filipe Mordhorst!
 - 2012-02-15 Added Italian translation, thanks to Massimo Bianchi!

#2.1.1 - 2012-02-14
 - 2012-02-14 First stable release for OTRS 3.1.x series.

#2.1.0.beta4 - 2012-01-27
 - 2012-01-20 Fixed bug#[8130](http://bugs.otrs.org/show_bug.cgi?id=8130) - Editing of General Info on Master Survey on possible.

#2.1.0.beta3 - 2011-02-18
 - 2011-02-16 Fixed bug#[6826](http://bugs.otrs.org/show_bug.cgi?id=6826) - Survey shows blank overview screen by database error.
 - 2011-02-11 Fixed bug#[6865](http://bugs.otrs.org/show_bug.cgi?id=6865) - Norwegian translation for survey module.

#2.1.0.beta2 - 2011-02-04
 - 2011-02-02 Fixed bug#[6849](http://bugs.otrs.org/show_bug.cgi?id=6849) - Survey Emails are not sending correct content.
 - 2011-01-31 - Improved HTML view on SurveyZoom related to bug#[4784](http://bugs.otrs.org/show_bug.cgi?id=4784).
 - 2011-01-31 - Implemented - Show survey answered on read-only mode.
    http://otrsteam.ideascale.com/a/dtd/Show-survey-answered-on-read-only-mode./103470-10369.
 - 2011-01-25 Fixed bug#[6746](http://bugs.otrs.org/show_bug.cgi?id=6746) - Survey beta 1 does not install with ITSM.

#2.1.0.beta1 - 2011-01-21
 - Init release for OTRS 3.0.
 - Implemented bug#[5973](http://bugs.otrs.org/show_bug.cgi?id=5973) - Improve Survey-Key invalid message when survey is answered once.
 - Implemented bug#[4784](http://bugs.otrs.org/show_bug.cgi?id=4784) - no WYSIWYG editor available composing email text.
 - Fixed bug#[6711](http://bugs.otrs.org/show_bug.cgi?id=6711) - Question up arrow doesn't works.
 - Fixed bug#[6712](http://bugs.otrs.org/show_bug.cgi?id=6712) - Answer up arrow doesn't works.
 - Fixed bug#[6714](http://bugs.otrs.org/show_bug.cgi?id=6714) - Stat Details shows just one answer for questions with more than one like Checkbox.

EOF
