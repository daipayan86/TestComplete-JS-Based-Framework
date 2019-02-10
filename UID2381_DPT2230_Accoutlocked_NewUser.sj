﻿//USEUNIT _begin
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
//USEUNIT Unexpected_Window
/************************************************************************************
Test Steps:
===========
Step1 Log in as a first time user.
Result: User logged in .

Step2 enter new password,confirm password,security question and answer.And click on save.
Result:Pop up displayed ''password change successfully''.

Step3 Try to login with invalid password 3 times for the same first time user.
Result:Getting error message "Username or password is invalid.Please try again''.

Step 4 Try to login again with invalid password.
Result:User account got locked and pop up message displayed "Your account has been approced or is locked.Please contact your system administrator for more information.

Step 5 "Click on the forgot Password
Result: Displayed a pop up with username filed

Step 6 enter the username and click on submit
Result:Pop up dispalyed to enter security answer

Step7 Enter security answer and click on submit.
Result:Pop up displayed for enter new password and confirm password.

Step 8 Enter the password and click on submit.Click OK on the Successful Password change pop up
Result: User able to logged in after changing the password.


Created By: Janardhana.
***********************************************************************************/
function UID2381() {
    Properties.TC = "UID2381_DPT2230_Accoutlocked_NewUser";
    CommonFuncs.Begin_test();


    //precondition
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
   AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD);
    var objFirstname = Properties.USER_FIRSTNAME + CommonFuncs.Get_unique_id();
    var objLastname = Properties.USER_LASTNAME + CommonFuncs.Get_unique_id();
    var objUsername = Properties.USER_NAME + CommonFuncs.Get_unique_id();
    var objPassword = Properties.PASSWORD;
    var objConfirmPwd = Properties.RE_PASSWORD;
    var objNewPassword = Properties.NEW_PASSWORD;
    var objNewConfirmPwd = Properties.NEW_CONFIRMPWD;
    var objSecurityQuestion = Properties.SECURITY_QUESTION;
    var objSecurityAnswer = Properties.SECURITY_ANSWER;
    var objRoleName = Properties.SERVICE_ROLE;
    var objForNewPassword = Properties.FORGOT_NEW_PASSWORD;
    var objForNewConfirmPwd = Properties.FORGOT_NEW_CONFIRMPWD;
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    AmazonCommonFuncs.clickBtnAndVerifyPage("Create User", "Add User");
    AmazonCommonFuncs.createUser(objFirstname, objLastname, objUsername, objPassword, objConfirmPwd, objRoleName);
    AmazonCommonFuncs.MenuNavigate("Log Out");
    Delay(wait_time);

     //Step1 Log in as a first time user.
     //Result: User logged in .
    if (AmazonCommonFuncs.changePwdLogin(objUsername,objPassword)) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }
    
    //Step2 enter new password,confirm password,security question and answer.And click on save.
    //Result:Pop up displayed ''password change successfully''.
    if (changePwdSuccessMsg(objPassword,objNewPassword,objNewConfirmPwd,objSecurityQuestion,objSecurityAnswer)) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step3 Try to login with invalid password 3 times for the same first time user.
    //Result:Getting error message "Username or password is invalid.Please try again''.
   var objFirstTime = AmazonCommonFuncs.invalidloginAttempts(objUsername, Properties.WRONG_PASSWORD);
   var objSecondTime = AmazonCommonFuncs.invalidloginAttempts(objUsername, Properties.WRONG_PASSWORD);
   var objThirdTime = AmazonCommonFuncs.invalidloginAttempts(objUsername, Properties.WRONG_PASSWORD);
    if (objFirstTime && objSecondTime && objThirdTime) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    //Step 4 Try to login again with invalid password.
    //Result:User account got locked and pop up message displayed "Your account has been approced or is locked.Please contact your system administrator for more information.
    if (AmazonCommonFuncs.invalidLogin(objUsername,Properties.WRONG_PASSWORD)) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }

     //Step 5 "Click on the forgot Password
    //Result: Displayed a pop up with username filed
    AmazonCommonFuncs.clickOnLink("Forgot Password");
    var objForgotPwdScreen = verifyForgotPwdScreen("Forgot Password", "User Name");
    if (objForgotPwdScreen) {
        ReportCommonFuncs.Report_a_verify(5, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(5, "Fail", "Y");
    }

    //Step 6 enter the username and click on submit
    //Result:Pop up dispalyed to enter security answer
    enterValueInField("Forgot Password", "User Name", objUsername, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    var objSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Security Question");
    var objAnsToSecuQue = verifyForgotPwdScreen("Forgot Password Security Question", "Answer to Security Question");
    if (objSecuQue && objAnsToSecuQue) {
        ReportCommonFuncs.Report_a_verify(6, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(6, "Fail", "Y");
    }

     //Step7 Enter security answer and click on submit.
     //Result:Pop up displayed for enter new password and confirm password.
    enterValueInField("Forgot Password Security Question", "Answer to Security Question", objSecurityAnswer, "TextBox");
    AmazonCommonFuncs.clickBtnByName("Submit");
    var objNewPassword = verifyForgotPwdScreen("Forgotten Password Reset Screen", "New Password");
    var objConfirmPwd = verifyForgotPwdScreen("Forgotten Password Reset Screen", "Password Confirmation");
    if (objNewPassword && objConfirmPwd) {
        ReportCommonFuncs.Report_a_verify(7, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(7, "Fail", "Y");
    }

    //Step 8 Enter the password and click on submit.Click OK on the Successful Password change pop up
    //Result: User able to logged in after changing the password.
    enterValueInField("Forgotten Password Reset Screen", "New Password", Properties.FORGOT_NEW_PASSWORD, "PasswordBox");
    enterValueInField("Forgotten Password Reset Screen", "Password Confirmation", Properties.FORGOT_NEW_CONFIRMPWD, "RePasswordBox");
    AmazonCommonFuncs.clickBtnByName("Save");
    Delay(wait_time);
    verifysuccessMsg("Change Password", "Password Changed Successfull..", true);
    Delay(wait_time_very_long);
    Delay(wait_time_very_long);
    ClickNotificationWindow1("OK", "PopupActionWindow");
    Delay(wait_time_very_long);
    ClickNotificationWindow1("OK", "HwndSource");
    Delay(wait_time_long);
    Delay(wait_time_long);
    if (verifyUser(objUsername)) {
        ReportCommonFuncs.Report_a_verify(8, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(8, "Fail", "Y");
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
                objVerifyField.Keys("^a[BS]");
                objVerifyField.Keys(valuetoEnter);
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
                    PropArray = new Array("ClrClassName","WPFControlText");
                    ValuesArray = new Array("ContentControl",ContentText);
                    var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
                    if (aqString.Find(notificationwindowOkBtn.Content, ContentText) != -1) {
                        clickOKOnSuccessMsg(Screenname);
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
function changePwdSuccessMsg(objOldPassword,objNewPassword,objNewConfirmPwd,objSecurityQuestion,objSecurityAnswer) {
        try {
                AmazonCommonFuncs.EnterAnyText("Old Password", objOldPassword, "PasswordBox");
                AmazonCommonFuncs.EnterAnyText("New Password", objNewPassword, "PasswordBox");
                AmazonCommonFuncs.EnterAnyText("Password Confirmation", objNewConfirmPwd, "PasswordBox");
                AmazonCommonFuncs.EnterAnyText("Security Question", objSecurityQuestion, "TextBox");
                AmazonCommonFuncs.EnterAnyText("Answer to Security Question", objSecurityAnswer, "TextBox");
                AmazonCommonFuncs.clickBtnByName("Save");
                var objMsg = verifyChangePwdMsg("Password Changed Successfull..", true);
                if (objMsg) {
                    Log.Message("Password changed succesfully");
                    return true;
                } else {
                    Log.Message("Password was not changed");
                    return false;
                }
        } catch (e) {
            Log.Message("changePwd() Error" + e.description);
        }
        }

}