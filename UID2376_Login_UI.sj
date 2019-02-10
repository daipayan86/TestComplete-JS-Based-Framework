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
//USEUNIT Unexpected_Window
/************************************************************************************
Test Steps:
===========
Step1 Launch the application from the desktop.
Result: It displays Login page.

Step2 Verify login page
Result: User is able to see below fields:
User name
Password
Login button 
Forgot password button

Created By: Janardhana 
***********************************************************************************/
function UID2376() {
    Properties.TC = "UID2376_Login_UI";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);

    //Step1 Launch the application from the desktop.
    //Result: It displays Login page. 

    if (AmazonCommonFuncs.LoadApplication(Properties.APP_NAME)) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step2 Verify login page
    //Result: User is able to see below fields:
    //"User name" "Password" ""Login button" "Forgot password"

    var objUserName = AmazonCommonFuncs.verifyLabel("User Name");
    var objPassword = AmazonCommonFuncs.verifyLabel("Password");
    var objLoginBtn = AmazonCommonFuncs.verifyBtnByName("Login");
    var objForgotPasswordLink = AmazonCommonFuncs.verifyLabel("Forgot Password");
    if (objUserName && objPassword && objLoginBtn && objForgotPasswordLink) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();
}