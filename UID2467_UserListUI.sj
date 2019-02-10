//USEUNIT _begin
//USEUNIT _end
//USEUNIT AmazonCommonFuncs
//USEUNIT CommonFuncs
//USEUNIT CommonVars
//USEUNIT DbConn
//USEUNIT HTMLReporting
//USEUNIT Import
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
Step 1	:Login into Avenio(Millisect) with valid credentials.
User Name: admin
Password: admin
Result:User logs in successfully.
Step 2:Click on User menu, Select Administration area and Click on User Management tab,Verify User List UI
Result:For each user account the User List page shall present:  
User Name 
First Name 
Last Name 
User Role 
User Status: ACTIVE/INACTIVE
Access: LOCKED/UNLOCKED
Edit button
Create User button
Step 3:Verify the roles displayed for the users.
Result:For Admin user: Adminstrator,For Operator user: Operator,For Service user: Service
Step 4:Verify that the admin user is able to see both ACTIVE and INACTIVE users in the list.
Result:The admin user is able to see both ACTIVE and INACTIVE users in the list.
Step 5:Click on the Create User button and verify the UI.
Result:User navigate to add user page and It displays:
First Name
Last Name
UserName
Email
Password 
Reenter Password
Role
User status   
User access(with radio buttons for Unlocked and Locked)
Buttons:
Cancel
Save
Step 6:Verify the user status is "Active" by default.
Result:User status is "Active"  by default.
Step 7:Click on Cancel button with out entering the data.
Result:User is navigated to the User list page.
Step 8:Click on Edit  for any  particular user and verify the UI.
Result:User details are seen in  editable screen
It displays the following fileds:
User Name(Not Editable)
E-mail
Password
Re-enter Password
First name
User role
Last name
User status(with a default Active checkbox)
User access(with radio buttons for Unlocked and Locked)
Buttons
Cancel
Save

Created By : Keerthi                
***********************************************************************************/
function UID2467() {
    Properties.TC = "UID2467_UserListUI";
    CommonFuncs.Begin_test();

    //precondition
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
    AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD);
    var objFirstname1 = Properties.USER_FIRSTNAME + CommonFuncs.Get_unique_id();
    var objLastname1 = Properties.USER_LASTNAME + CommonFuncs.Get_unique_id();
    var objUsername1 = Properties.USER_NAME + CommonFuncs.Get_unique_id();
    var objPassword1 = Properties.PASSWORD;
    var objConfirmPwd1 = Properties.RE_PASSWORD;
    var objRoleName1 = Properties.SERVICE_ROLE;
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    AmazonCommonFuncs.clickBtnAndVerifyPage("Create User", "Add User");
    AmazonCommonFuncs.createUser(objFirstname1, objLastname1, objUsername1, objPassword1, objConfirmPwd1, objRoleName1);
    var objFirstname2 = Properties.USER_FIRSTNAME + CommonFuncs.Get_unique_id();
    var objLastname2 = Properties.USER_LASTNAME + CommonFuncs.Get_unique_id();
    var objUsername2 = Properties.USER_NAME + CommonFuncs.Get_unique_id();
    var objPassword2 = Properties.PASSWORD;
    var objConfirmPwd2 = Properties.RE_PASSWORD;
    var objRoleName2 = Properties.SERVICE_ROLE;
    createInactiveUser(objFirstname2, objLastname2, objUsername2, objPassword2, objConfirmPwd2, objRoleName2);
    AmazonCommonFuncs.MenuNavigate("Log Out");
    Delay(wait_time);

    //Step 1	:Login into Avenio(Millisect) with valid credentials.
    //User Name: admin
    //Password: admin
    //Result:User logs in successfully.
    if (AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD)) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step 2:Click on User menu, Select Administration area and Click on User Management tab,Verify User List UI
    //Result:For each user account the User List page shall present:  
    //User Name 
    //First Name 
    //Last Name 
    //User Role 
    //User Status: ACTIVE/INACTIVE
    //Access: LOCKED/UNLOCKED
    //Edit button
    //Create User button
    AmazonCommonFuncs.MenuNavigate("Administration");
    AmazonCommonFuncs.ClickMenuitem("User Management");
    if (verifyUserListHeaderPart()) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step 3:Verify the roles displayed for the users.
    //Result:For Admin user: Adminstrator,For Operator user: Operator,For Service user: Service
    var objAdminRole = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "admin", "User Role", Properties.ADMIN_ROLE);
    var objServiceRole = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "service", "User Role", Properties.SERVICE_ROLE);
    var objOperatorRole = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "operator", "User Role", Properties.OPERATOR_ROLE);
    if (objAdminRole && objServiceRole && objOperatorRole) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    //Step 4:Verify that the admin user is able to see both ACTIVE and INACTIVE users in the list.
    //Result:The admin user is able to see both ACTIVE and INACTIVE users in the list.
    var objActiveUser = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", objUsername1, "User Status", "ACTIVE");
    var objInActiveUser = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", objUsername2, "User Status", "INACTIVE");
    if (objActiveUser && objInActiveUser) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }

    //Step 5:Click on the Create User button and verify the UI.
    //Result:User navigate to add user page and It displays:
    //First Name
    //Last Name
    //UserName
    //Email
    //Password 
    //Reenter Password
    //Role
    //User status   
    //User access(with radio buttons for Unlocked and Locked)
    //Buttons:Cancel,Save
    AmazonCommonFuncs.clickBtnByName("Create user");
    if (verifyCreateUser()) {
        ReportCommonFuncs.Report_a_verify(5, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(5, "Fail", "Y");
    }

    //Step 6:Verify the user status is "Active" by default.
    //Result:User status is "Active"  by default.
    var Page = CommonVars.page;
    PropArray = new Array("ClrClassName", "IsChecked");
    ValuesArray = new Array("CheckBox", "True");
    varobjCheckbox = Page.Find(PropArray, ValuesArray, _depth);
    if (varobjCheckbox) {
        ReportCommonFuncs.Report_a_verify(6, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(6, "Fail", "Y");
    }

    //Step 7:Click on Cancel button with out entering the data.
    //Result:User is navigated to the User list page.
    AmazonCommonFuncs.clickBtnByName("Cancel");
    if (SysAdminCommonFuncs.verifyUserList()) {
        ReportCommonFuncs.Report_a_verify(7, "PASS", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(7, "Fail", "Y");
    }

    //Step 8:Click on Edit  for any  particular user and verify the UI.
    //Result:User details are seen in  editable screen
    //It displays the following fileds:
    //User Name(Not Editable)
    //E-mail
    //Password
    //Re-enter Password
    //First name
    //User role
    //Last name
    //User status(with a default Active checkbox)
    //User access(with radio buttons for Unlocked and Locked)
    //Buttons:Cancel,Save
    AmazonCommonFuncs.clickBtnByName("Edit");
    if (verifyEditUser()) {
        ReportCommonFuncs.Report_a_verify(8, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(8, "Fail", "Y");
    }
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();

    function verifyUserListHeaderPart() {
        try {
            var objUserName = verifyHeader("User Name");
            var objFirstName = verifyHeader("First Name ");
            var objLatsName = verifyHeader("Last Name");
            var objUserRole = verifyHeader("User Role");
            var objAccess = verifyHeader("Access");
            var objUserStatus = verifyHeader("User Status");
            var objCreateUser = AmazonCommonFuncs.verifyBtnByName("Create user");
            var objEdit = AmazonCommonFuncs.verifyBtnByName("Edit");
            var objUserAccessText = verifyUserAccessStatusText("Access", "LOCKED", "Unlocked");
            var objUserStatusText = verifyUserAccessStatusText("User Status", "ACTIVE", "INACTIVE");
            if (objUserName && objUserAccessText && objUserStatusText && objEdit && objFirstName && objLatsName && objUserRole && objAccess && objUserStatus && objCreateUser && objEdit) {
                Log.Message("User List Header part tabs are avaliable");
                return true;
            } else {
                Log.Message("User List Header part tabs are not avaliable");
                return false;
            }
        } catch (e) {
            Log.Message("verifyUserListHeaderPart() Error" + e.description);
            return false;
        }
    }

    function verifyHeader(headerName) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("DataGridColumnHeader", headerName);
            var objtxtheader = Page.Find(PropArray, ValuesArray, _depth);
            if (objtxtheader.Exists) {
                objtxtheader.HoverMouse();
                Log.Message(headerName + "Header is avaliable");
                return true;
            } else {
                Log.Message(headerName + "Header is not avaliable");
                return false;
            }
        } catch (e) {
            Log.Message("verifyHeader() Error" + e.description);
            return false;
        }
    }

    function verifyUserAccessStatusText(columnNameVerify, valueNameVerifyFirst, valueNameVerifySecond) {
        try {
            var objAdmin = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "admin", columnNameVerify, valueNameVerifyFirst) || AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "admin", columnNameVerify, valueNameVerifySecond);
            var objOperator = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "operator", columnNameVerify, valueNameVerifyFirst) || AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "operator", columnNameVerify, valueNameVerifySecond);
            var objService = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "service", columnNameVerify, valueNameVerifyFirst) || AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "service", columnNameVerify, valueNameVerifySecond);
            if (objAdmin && objOperator && objService) {
                Log.Message("User" + columnNameVerify + valueNameVerifyFirst + "/" + valueNameVerifySecond + "  is available");
                return true;

            } else {
                Log.Message("User" + columnNameVerify + valueNameVerifyFirst + "/" + valueNameVerifySecond + "  is not available");
                return false;

            }
        } catch (e) {
            Log.Message("objUserAccessStatusText() Error" + e.description);
            return false;
        }
    }

    function createInactiveUser(FirstName, LastName, UserName, Password, CofirmPassword, RoleName) {
        try {
            AmazonCommonFuncs.clickBtnByName("Create user");
            AmazonCommonFuncs.EnterAnyText("First Name    *", FirstName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("Last Name   *", LastName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("User Name   *", UserName, "TextBox");
            AmazonCommonFuncs.EnterAnyText("Password   *", Password, "PasswordBox");
            AmazonCommonFuncs.EnterAnyText("Re-Enter Password   *", CofirmPassword, "PasswordBox");
            AmazonCommonFuncs.EnterAnyText("Role   *", RoleName, "ComboBox");
            AmazonCommonFuncs.enterTextNearLabel("ACTIVE", "Unchecked", "CheckBox");
            AmazonCommonFuncs.clickBtnByName("Save");
            AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
            Delay(wait_time_long);
            var objTableDataVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", UserName, "First Name", FirstName);
            if (objTableDataVerify) {
                Log.Message(UserName + "Exists in the User List");
                return true;
            } else {
                Log.Message(UserName + "Not Exists in the User List");
                return false;
            }
        } catch (e) {
            Log.Message("createInactiveUser() Error" + e.description);
        }
    }

    function verifyCreateUser() {
        try {
            var objFirstName = AmazonCommonFuncs.VerifyAnyText("First Name    *", "TextBox");
            var objLastName = AmazonCommonFuncs.VerifyAnyText("Last Name   *", "TextBox");
            var objUserName = AmazonCommonFuncs.VerifyAnyText("User Name   *", "TextBox");
            var objEmail = AmazonCommonFuncs.VerifyAnyText("Email", "TextBox");
            var objPassword = AmazonCommonFuncs.VerifyAnyText("Password   *", "PasswordBox");
            var objReeneterPassword = AmazonCommonFuncs.VerifyAnyText("Re-Enter Password   *", "PasswordBox");
            var objRole = AmazonCommonFuncs.VerifyAnyText("Role   *", "ComboBox");
            var objStatus = AmazonCommonFuncs.VerifyAnyText("ACTIVE", "CheckBox");
            var objUnlocked = AmazonCommonFuncs.VerifyAnyText("Unlocked", "RadioButton");
            var objLocked = AmazonCommonFuncs.VerifyAnyText("LOCKED", "RadioButton");
            var objCancel = AmazonCommonFuncs.verifyBtnByName("Cancel");
            var objSave = AmazonCommonFuncs.verifyBtnByName("Save");
            if (objFirstName && objLastName && objUserName && objEmail && objPassword && objReeneterPassword &&
                objRole && objLocked && objUnlocked && objStatus && objCancel && objSave) {
                return true;
            } else {
                return false;
            }
        } catch (e) {
            Log.Message("verifyCreateUser() Error" + e.description);
        }
    }

    function verifyEditUser() {
        try {
            var objFirstName = AmazonCommonFuncs.VerifyAnyText("First Name    *", "TextBox");
            var objLastName = AmazonCommonFuncs.VerifyAnyText("Last Name   *", "TextBox");
            var Page = CommonVars.page;
            PropArray = new Array("ClrClassName", "IsEnabled");
            ValuesArray = new Array("TextBox", "False");
            var objUserName = Page.Find(PropArray, ValuesArray, _depth);
            var objEmail = AmazonCommonFuncs.VerifyAnyText("Email", "TextBox");
            var objPassword = AmazonCommonFuncs.VerifyAnyText("Password   *", "PasswordBox");
            var objReeneterPassword = AmazonCommonFuncs.VerifyAnyText("Re-Enter Password   *", "PasswordBox");
            var objRole = AmazonCommonFuncs.VerifyAnyText("Role   *", "ComboBox");
            var objStatus = AmazonCommonFuncs.VerifyAnyText("ACTIVE", "CheckBox");
            var objUnlocked = AmazonCommonFuncs.VerifyAnyText("Unlocked", "RadioButton");
            var objLocked = AmazonCommonFuncs.VerifyAnyText("LOCKED", "RadioButton");
            var objCancel = AmazonCommonFuncs.verifyBtnByName("Cancel");
            var objSave = AmazonCommonFuncs.verifyBtnByName("Save");
            if (objFirstName && objLastName && objUserName && objEmail && objPassword && objReeneterPassword &&
                objRole && objLocked && objUnlocked && objStatus && objCancel && objSave) {
                return true;
            } else {
                return false;
            }
        } catch (e) {
            Log.Message("verifyEditUser() Error" + e.description);
        }
    }
}