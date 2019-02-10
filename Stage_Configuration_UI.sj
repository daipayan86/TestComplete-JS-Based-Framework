//USEUNIT _begin
//USEUNIT _end
//USEUNIT AmazonCommonFuncs
//USEUNIT CommonFuncs
//USEUNIT CommonVars
//USEUNIT DbConn
//USEUNIT HTMLReporting
//USEUNIT Import
//USEUNIT Library
//USEUNIT PreConditionScript
//USEUNIT Properties
//USEUNIT ReportCommonFuncs
//USEUNIT Repository
//USEUNIT SysAdminCommonFuncs
//USEUNIT Unexpected_Window
/************************************************************************************
Test Steps:
===========
<Step1>
	<Action>Login as admin user.
			admin/admin        
	</Action> 
	<Expected>It successfully logs into Avenio(Millisect) application.It displays case list.</Expected> 
	<Actual>It does not successfully logs into Avenio(Millisect) application.It does not displays case list.</Actual> 
</Step1>
<Step2>
	<Action>Click on Administration , from user pull-down menu and navigate to Capture Configuration</Action> 
	<Expected>User is in Capture Configuration page</Expected> 
	<Actual>User is unable to go to Capture Configuration page</Actual> 
</Step2>
<Step3>
	<Action>In  the Capture Configuration menu, verify the contents.</Action> 
	<Expected>The following controls are available
    •	Default backdrop illumination radio buttons for White, Black, and None
    •	Default Illumnation slider bar
    •	Live Camera View window 
    Save
    Cancel.
  </Expected> 
	<Actual>User is not able to verify the contents of the capture configuration.</Actual> 
</Step3>

Created By: Daipayan   Date: 11/06/2017
***********************************************************************************/
function UID2411() {
    Properties.TC = "UID2411_962_CaptureConfiguration_UI";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
    /***************************
    Step 1 Login as admin user.
		Username: admin
		Password: admin
  
    Result: It successfully logs into Avenio(Millisect) application.It displays case list
    ************************************************************/
    
    if (AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD)){
    ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }    

    /******************************
	<Action>Click on Administration , from user pull-down menu and navigate to Capture Configuration</Action> 
	<Expected>User is in Capture Configuration page</Expected> 
    *********************************/
AmazonCommonFuncs.MenuNavigate("Administration");
    var objAdminMenu1 = AmazonCommonFuncs.ClickMenuitem("Stage Configuration");
            
    if (objAdminMenu1 ) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "Y");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }
    

/******************************
<Step3>
<Action>In  the Capture Configuration menu, verify the contents.</Action> 
	<Expected>The following controls are available
    •	Default backdrop illumination radio buttons for White, Black, and None
    •	Default Illumnation slider bar
    •	Live Camera View window 
    Save
    Cancel.
  </Expected> 
*******************************/
    var objhead = SysAdminCommonFuncs.VerifyFields("Stage Configuration","TextBlock");
    var objrad1 = SysAdminCommonFuncs.VerifyFields("Stage Position 1","RadioButton","Active");
    var objrad2 = SysAdminCommonFuncs.VerifyFields("Stage Position 1","RadioButton","Inactive");
    var objrad3 = SysAdminCommonFuncs.VerifyFields("Stage Position 2","RadioButton","Active");
    var objrad4 = SysAdminCommonFuncs.VerifyFields("Stage Position 2","RadioButton","Inactive");
    var objrad5 = SysAdminCommonFuncs.VerifyFields("Stage Position 3","RadioButton","Active");
    var objrad6 = SysAdminCommonFuncs.VerifyFields("Stage Position 3","RadioButton","Inactive");
    var objrad7 = SysAdminCommonFuncs.VerifyFields("Stage Position 4","RadioButton","Active");
    var objrad8 = SysAdminCommonFuncs.VerifyFields("Stage Position 4","RadioButton","Inactive");
    var objrad9 = SysAdminCommonFuncs.VerifyFields("Barcode Type","RadioButton","1D");
    var objrad10 = SysAdminCommonFuncs.VerifyFields("Barcode Type","RadioButton","2D");
    var objrad11 = SysAdminCommonFuncs.VerifyFields("Barcode Type","RadioButton","None");
    var objrad12 = SysAdminCommonFuncs.VerifyFields("Fill Station","RadioButton","Active");
    var objrad13 = SysAdminCommonFuncs.VerifyFields("Fill Station","RadioButton","Inactive");
    var objrad14 = SysAdminCommonFuncs.VerifyFields("Tip Rotation Speed","Slider");
    var objrad15 = SysAdminCommonFuncs.VerifyFields("Tip Rotation Speed","DecimalUpDown");
    var objrad16 = SysAdminCommonFuncs.VerifyFields("Tip Rotation Speed","Slider");
    var objrad17 = SysAdminCommonFuncs.VerifyFields("Tip Rotation Speed","DecimalUpDown");
    var objrad18 = SysAdminCommonFuncs.VerifyFields("Aspiration Speed","Slider");
    var objrad19 = SysAdminCommonFuncs.VerifyFields("Aspiration Speed","DecimalUpDown");
    var objsave= AmazonCommonFuncs.verifyBtnByName("Save");
    
    
    
     if (objhead && objrad1 && objrad2 && objrad3 && objrad4 && objrad5 && objrad6 && objrad7 && objrad8 && objrad9 && objrad10 && objsave && objrad11 && objrad12 && objrad13 && objrad14 && objrad15 && objrad16 && objrad17 && objrad18 && objrad19) {
            ReportCommonFuncs.Report_a_verify(3, "Pass", "Y");
      }
      else {
            ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
        }
        CommonFuncs.Verify_final_result(_final_result);
        CommonFuncs.Finish_test();
}