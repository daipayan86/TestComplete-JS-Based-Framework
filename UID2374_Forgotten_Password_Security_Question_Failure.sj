//USEUNIT _begin
//USEUNIT _end
//USEUNIT AmazonCommonFuncs
//USEUNIT CommonFuncs
//USEUNIT CommonVars
//USEUNIT DbConn
//USEUNIT HTMLReporting
//USEUNIT Library
//USEUNIT Properties
//USEUNIT ReportCommonFuncs
//USEUNIT Repository
//USEUNIT SysAdminCommonFuncs
//USEUNIT UID2489_Precondition
//USEUNIT Unexpected_Window
/************************************************************************************
Test Steps:
===========
Step1 Click on Forgot Password on the Login screen and verfiy the UI.
Result: It displays a dialog box prompting the user to enter a User Name

Step2 Enter an invalid username
Result:System  indicate the error pop up "Invalid user,Please provide valid username"

Step3 On clicking OK on the error pop up, verify the navigation
Result:User  bought back to the Recover Password screen

Step 4 "Click on the forgot Password link Enter  the User Name."
Result: User shall be prompted with the Security Question and Answer pop up

Step 5 Verify if the Security Question and Answer pop up appears
Result:Security Question and answer pop up appears

Step 6 Click on the Cancel button
Result:The user  brought back to the Login page

Step7 Click on the  Forgot Password link
Result:It displays a dialog box prompting the user to enter a User Name

Step 8 Enter  User Name.
Result: It displays a dialog box with the security question and prompt the user for a response.

Step 9 Enter an invalid response.
Result:It is not displaying  the Change Password Screen and indicates that the answer is wrong.


Created By: Janardhana.
***********************************************************************************/
function UID2374() {
    Properties.TC = "UID2374_Forgotten_Password_Security_Question_Failure";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);

    //Step1 Click on Forgot Password on the Login screen and verfiy the UI.
    //Result: It displays a dialog box prompting the user to enter a User Name
    AmazonCommonFuncs.clickOnLink("Forgot Password");
    var objForgotPwdScreen = verifyForgotPwdScreen("Forgot Password", "User Name");
    var objSubmitBtn = AmazonCommonFuncs.verifyBtnByName("Submit");
    var objCancelBtn = AmazonCommonFuncs.verifyBtnByName("Cancel");
    if (objForgotPwdScreen && objSubmitBtn && objCancelBtn) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }
    //Step2 Enter an invalid username
    //Result:System  indicate the error pop up "Invalid user,Please provide valid username"
    enterValueInField("Forgot Password", "User Name", Properties.INVALID_USER, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    if (AmazonCommonFuncs.verifyChangePwdMsg("Invalid User. Please Provide Valid User Name", true)) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step3 On clicking OK on the error pop up, verify the navigation
    //Result:User  bought back to the Recover Password screen
    if (verifyForgotPwdScreen("Forgot Password", "User Name")) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    //Step 4 "Click on the forgot Password link Enter  the User Name."
    //Result: User shall be prompted with the Security Question and Answer pop up
    enterValueInField("Forgot Password", "User Name", Properties.FIRSTTIME_USER, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    var objSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Security Question");
    var objAnsToSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Answer to Security Question");
    if (objSecuQue && objAnsToSecuQue) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }

    //Step 5 Verify if the Security Question and Answer pop up appears
    //Result:Security Question and answer pop up appears
    var objSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Security Question");
    var objAnsToSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Answer to Security Question");
    if (objSecuQue && objAnsToSecuQue) {
        ReportCommonFuncs.Report_a_verify(5, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(5, "Fail", "Y");
    }

    //Step 6 Click on the Cancel button
    //Result:The user  brought back to the Login page
    AmazonCommonFuncs.clickBtnByName("Cancel");
    if (AmazonCommonFuncs.verifyLandingPage()) {
        ReportCommonFuncs.Report_a_verify(6, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(6, "Fail", "Y");
    }

    //Step7 Click on the  Forgot Password link
    //Result:It displays a dialog box prompting the user to enter a User Name
    AmazonCommonFuncs.clickOnLink("Forgot Password");
    var objForgotPwdScreen = verifyForgotPwdScreen("Forgot Password", "User Name");
    if (objForgotPwdScreen) {
        ReportCommonFuncs.Report_a_verify(7, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(7, "Fail", "Y");
    }

    //Step 8 Enter  User Name.
    //Result: It displays a dialog box with the security question and prompt the user for a response.
    enterValueInField("Forgot Password", "User Name", Properties.FIRSTTIME_USER, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    var objSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Security Question");
    var objAnsToSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Answer to Security Question");
    if (objSecuQue && objAnsToSecuQue) {
        ReportCommonFuncs.Report_a_verify(8, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(8, "Fail", "Y");
    }

    //Step 9 Enter an invalid response.
    //Result:It is not displaying  the Change Password Screen and indicates that the answer is wrong.
    enterValueInField("Forgot Password Security Question", "Answer to Security Question", Properties.INVALID_ANSWER, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    if (AmazonCommonFuncs.verifyChangePwdMsg("Invaid Security Answer,Please provide correct answer", true)) {
        ReportCommonFuncs.Report_a_verify(9, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(9, "Fail", "Y");
    }
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();

    function verifyForgotPwdScreen(screenName, labelName) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("WndCaption");
            ValuesArray = new Array(screenName);
            var objForgotPwdscreen = Page.Find(PropArray, ValuesArray, _depth);
            if (objForgotPwdscreen) {
                objForgotPwdscreen.SetFocus();
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", labelName);
                var objVerifyLabel = Page.Find(PropArray, ValuesArray, _depth);
                if (objVerifyLabel) {
                    Log.Message(labelName + "popup window is opened");
                    return true;
                } else {
                    Log.Message(labelName + "popup window is not opened");
                    return false;
                }
            } else {
                Log.Message(objForgotPwdscreen + "Not Found");
                return false;
            }
        } catch (e) {
            Log.Message("verifyForgotPwdScreen() Error" + e.description);
        }
    }

    function enterValueInField(screenName, labelName, valuetoEnter, elementtype) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("DefaultWindow", screenName);
            var objForgotPwdscreen = Page.Find(PropArray, ValuesArray, _depth);
            //var ScreenTopPx = objForgotPwdscreen.ScreenTop;
            if (objForgotPwdscreen) {
                objForgotPwdscreen.HoverMouse();
                objForgotPwdscreen.Click();
                PropArray = new Array("VisibleOnScreen", "WPFControlText");
                ValuesArray = new Array("True", labelName);
                var objVerifyLabel = objForgotPwdscreen.Find(PropArray, ValuesArray, _depth);
                var objparent = objVerifyLabel.Parent;
                //var ScreenTopPx = objVerifyLabel.ScreenTop;
                if (objVerifyLabel)
                    PropArray = new Array("Name", "VisibleOnScreen");
                ValuesArray = new Array("WPFObject(\"" + elementtype + "*", "True");
                var objVerifyField = objparent.Find(PropArray, ValuesArray, _depth);
                objVerifyField.Click();
                objVerifyField.SetText(valuetoEnter);
                if (objVerifyField.wText == valuetoEnter) {
                    Log.Message(valuetoEnter + "value is entered in the in the Field");
                    return true;
                } else {
                    Log.Message(valuetoEnter + "value is entered in the in the Field");
                    return false;
                }
            } else {
                Log.Message(objForgotPwdscreen + "Not Found");
                return false;
            }
        } catch (e) {
            Log.Message("enterValueInField1() Error" + e.description);
        }
    }

    function verifysuccessMsg(Screenname, ContentText, ifContains) {
        var ifContains = false || ifContains
        try {
            var Page = CommonVars.page;
            PropArray = new Array("WndCaption");
            ValuesArray = new Array(Screenname);
            var notificationwindow = Page.Find(PropArray, ValuesArray, _depth);
            //ClrClassName Content
            if (notificationwindow.Exists) {
                if (ifContains) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array("ContentControl");
                    var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
                    if (aqString.Find(notificationwindowOkBtn.Content, ContentText) != -1) {
                        //clickOKOnSuccessMsg(Screenname);
                        Log.Message("Substring '" + ContentText + "' was found in string '");
                        return true;
                    } else {
                        Log.Message("Substring '" + ContentText + "' was NOT found in string '");
                        return false;
                    }
                }
            }
        } catch (e) {
            Log.Message("verifyChangePwdMsg() Error" + e.description);
        }
    }

    function clickOKOnSuccessMsg(Screenname) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("WndCaption");
            ValuesArray = new Array(Screenname);
            var notificationwindow = Page.Find(PropArray, ValuesArray, _depth);
            if (notificationwindow.Exists) {
                PropArray = new Array("Name");
                ValuesArray = new Array("WPFObject(\"OKButton\")");
                var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
                if (notificationwindowOkBtn.Exists) {
                    notificationwindowOkBtn.Click();
                }
            }
        } catch (e) {
            Log.Message("clickOKOnNotificationWindow() Error" + e.description);
        }
    }

    function verifyUser(Username) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("ClrClassName", "Name");
            ValuesArray = new Array("TextBlock", "WPFObject(\"userNameText\")");
            var objUserVerfiy = Page.Find(PropArray, ValuesArray, _depth);
            PropArray = new Array("WPFControlText");
            ValuesArray = new Array("New Job");
            var objNewJobVerify = Page.Find(PropArray, ValuesArray, _depth);
            if (objUserVerfiy.WPFControlText == Username && objNewJobVerify.Exists) {
                Log.Message("User is logged in and Job list is displayed");
                return true;
            } else {
                return false;
            }
        } catch (e) {
            Log.Message("verifyUser() Error" + e.description);
        }
    }
}