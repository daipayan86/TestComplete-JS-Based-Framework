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
Step 1	:Login as admin user.
User Name : admin
Password : admin
Result:It successfully logs into Avenio(Millisect) application.It displays case list.
Step 2:Click on the Administration>User Management tab.
Result:User list is displayed.
Step 3:Click Create User button at the bottom of the page.
Result:It displays create user page.
Step 4:In create  user page enter
First Name : John
Last Name : Smith
User Name : QaUser4 -- (already exists)
Role : Administrator
Password : Password1!
Re-Enter Password : Password1
Click on Save button.
Result:It displays a popup indicating the error "Duplicate User".
Step 5:Verify duplicate users are not listing in user list.
Result:Duplicate user are not listing  in user list.


Created By : Keerthi               
***********************************************************************************/
function UID2474() {
    Properties.TC = "UID2474_Duplicate_User_Creation";
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
    var objNewPwd = Properties.NEW_PASSWORD;
    var objNewConfirmPwd = Properties.NEW_CONFIRMPWD;
    var objRoleName = Properties.ADMIN_ROLE;
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    AmazonCommonFuncs.clickBtnAndVerifyPage("Create User", "Add User");
    AmazonCommonFuncs.createUser(objFirstname, objLastname, objUsername, objPassword, objConfirmPwd, objRoleName);
    AmazonCommonFuncs.MenuNavigate("Log Out");
    Delay(wait_time);

    //Step 1	:Login as admin user.
    //User Name : admin
    //Password : admin
    //Result:It successfully logs into Avenio(Millisect) application.It displays case list.
    if (AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD)) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step2 :Click on the Administration>User Management tab.
    //Result:User list is displayed.
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    if (SysAdminCommonFuncs.verifyUserList()) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step 3:Click Create User button at the bottom of the page.
    //Result:It displays create user page.
    if (AmazonCommonFuncs.clickBtnAndVerifyPage("Create user", "Add User")) {
        ReportCommonFuncs.Report_a_verify(3, "PASS", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    // Step 4:In create  user page enter
    //First Name : John
    //Last Name : Smith
    //User Name : QaUser4 -- (already exists)
    //Role : Administrator
    //Password : Password1!
    //Re-Enter Password : Password1
    //Click on Save button.
    //Result:It displays a popup indicating the error "Duplicate User".
    createDuplicateUser(objFirstname, objLastname, objUsername, objPassword, objConfirmPwd, objRoleName);
    if (AmazonCommonFuncs.VerifyNotificationWindowMsg("Duplicate User", true)) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }

    // Step 5:Verify duplicate users are not listing in user list.
    //Result:Duplicate user are not listing  in user list.
    AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
    if (AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", objUsername, "First Name ", objFirstname)) {
        ReportCommonFuncs.Report_a_verify(5, "PASS", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(5, "Fail", "Y");
    }
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();

    function createDuplicateUser(FirstName, LastName, UserName, Password, CofirmPassword, RoleName) {
        try {
            AmazonCommonFuncs.EnterAnyText("First Name    *", FirstName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("Last Name   *", LastName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("User Name   *", UserName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("Password   *", Password, "PasswordBox");
            AmazonCommonFuncs.EnterAnyText("Re-Enter Password   *", CofirmPassword, "PasswordBox");
            AmazonCommonFuncs.EnterAnyText("Role   *", RoleName, "ComboBox");
            AmazonCommonFuncs.enterTextNearLabel("ACTIVE", "Checked", "CheckBox");
            AmazonCommonFuncs.clickBtnByName("Save");
            return true;
        } catch (e) {
            Log.Message("createDuplicateUser() Error" + e.description);
            return false;
        }
    }
}