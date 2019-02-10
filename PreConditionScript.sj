//USEUNIT Library 
//USEUNIT AmazonCommonFuncs
//USEUNIT SysAdminCommonFuncs

/* Created: 05/11/2016       Created By: Mobine Antony
*************************************************************************************/
function Precondition(){
  Properties.TC = "UID0000_01_Precondition";
  CommonFuncs.Begin_test();
  AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
 AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
  AmazonCommonFuncs.login(Properties.ADMIN_ID,Properties.ADMIN_PASSWORD);
  Delay(40000);
 // AmazonCommonFuncs.clickBtnByName("New Job");
  //Delay(3000);
 // AmazonCommonFuncs.EnterAnyText("Case ID","John","TextBox");
    AmazonCommonFuncs.createCaseAndVerify("UID1234","Charu","101","Male","12/09/1987",Properties.TISSUE_NAME,Properties.DOWNSTREAM_NAME);
    Delay(50000);
    AmazonCommonFuncs.createTissuePortion(50,50,150,150);
    AmazonCommonFuncs.clickBtnByName("SCAN STAGE");
//  AmazonCommonFuncs.MenuNavigate("Administration");
//  var objTissueTypeName = Properties.TISSUE_NAME+CommonFuncs.Get_unique_id();
//  var objDownStreamName = Properties.DOWNSTREAM_NAME+CommonFuncs.Get_unique_id();
//  AmazonCommonFuncs.createTissueType(objTissueTypeName);
//  AmazonCommonFuncs.createDownStream(objDownStreamName);
//  AmazonCommonFuncs.createTargetVolumes(objTissueTypeName,objDownStreamName,Properties.TARGET_VOLUME);
//  AmazonCommonFuncs.ClickMenuitem("Tissue Options");
//  Delay(3000);
//  AmazonCommonFuncs.selectTabAndVerify("Tissue Types","Add tissue type");
//  Delay(1000);
//  var objModifyValue = "ModifiedValue";
//  AmazonCommonFuncs.TableDataModify("WPFObject(\"DgTissueType\")","Name",objTissueTypeName,"Name",objModifyValue,"Edit tissue type");
//  AmazonCommonFuncs.TableDataVerify("WPFObject(\"DgTissueType\")","Name",objModifyValue,"Status","Active");

}