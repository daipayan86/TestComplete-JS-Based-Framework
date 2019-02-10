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
Step 1	:Login into Avenio(millisect) as Service user with invalid password for 4 times.	
Result  : User is locked.
Step 2	:Login as admin user in the same session.
Result  :	User logs in. Job list is displayed.
Step 3	:Navigate to Administration area>User management.
Result  :Verify access for Service user.Servie user access is locked.

Created By : Keerthi      
**********************************************************************************/
function UID2476() {
    Properties.TC = "UID2476_CornerCase_DPT2162_User_Status_Change_Same_Session";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);

    //Step 1	:Login into Avenio(millisect) as Service user with invalid password for 4 times.	
    //Result  : User is locked.
    var objFirstAttempt = AmazonCommonFuncs.invalidloginAttempts(Properties.SERVICE_USERID, Properties.INVALID_PASSWORD);
    var objSecondAttempt = AmazonCommonFuncs.invalidloginAttempts(Properties.SERVICE_USERID, Properties.INVALID_PASSWORD);
    var objThirdAttempt = AmazonCommonFuncs.invalidloginAttempts(Properties.SERVICE_USERID, Properties.INVALID_PASSWORD);
    var objFourthAttempt = AmazonCommonFuncs.invalidLogin(Properties.SERVICE_USERID, Properties.INVALID_PASSWORD);
    if (objFirstAttempt && objSecondAttempt && objThirdAttempt && objFourthAttempt) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step 2	:Login as admin user in the same session.
    //Result  :	User logs in. Job list is displayed.
    if (AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD)) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step 3	:Navigate to Administration area>User management.
    //Result  :Verify access for Service user.Servie user access is locked.
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    if (AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", Properties.SERVICE_USERID, "Access", "LOCKED")) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();
}