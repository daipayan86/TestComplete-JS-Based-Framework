//USEUNIT Library



function verifyUserPage(){  
  try{
  var createUserViewObj = CommonVars.page.Find(["Name","ClrClassName"], ["WPFObject(\"CreateUserView\"*", "TextBlock"], _depth);
	if (createUserViewObj) 
    return true;
  else 
    return false;
      }catch( e){
      Log.Message("verifyUserPage() Error"+e.description); 
    }
}

function verifyCaseList(){  
 try{
  var CaseListControlView = CommonVars.page.Find(["Name","ClrClassName"], ["WPFObject(\"OpenCaseListControl\")", "CaseListControlView"], _depth);
	if (CaseListControlView.VisibleOnScreen) 
    return true;
  else 
    return false;
      }catch( e){
      Log.Message("verifyCaseList() Error"+e.description); 
    }
}

function verifyUserList(){
try{
  var TableObj = CommonVars.page.Find(["Name","ClrClassName"], ["WPFObject(\"dgUsers\")", "DataGrid"], _depth);
	if (TableObj.Exists && TableObj.VisibleOnScreen)
    return true;
    else
    return false;
  }catch( e){
      Log.Message("verifyUserList() Error"+e.description); 
    }
}

function createUser(FName, LName, UName, Email, nPassword, RePassword, Role, UserStatus) {

    AmazonCommonFuncs.ClickMenuitem("User Management");
    Delay(3000);
    AmazonCommonFuncs.clickBtnByName("Create user");
    Delay(3000);
    enterLabelNearText("TextBox", "WPFObject(\"textFirstName\")", FName, "TextBox");
    enterLabelNearText("TextBox", "WPFObject(\"textLastName\")", LName, "TextBox");
    enterLabelNearText("TextBox", "WPFObject(\"textUserNameView\")", UName, "TextBox");
    enterLabelNearText("TextBox", "*WPFObject(\"TextBox\")*", Email, "TextBox");
    enterLabelNearText("PasswordBox", "WPFObject(\"PasswordBox\")", nPassword, "TextBox");
    enterLabelNearText("PasswordBox", "WPFObject(\"RePasswordBox\")", RePassword, "TextBox");
    enterLabelNearText("ComboBox", "WPFObject(\"RolesSelection\")", Role, "ComboBox");
    enterLabelNearText("CheckBox", "*WPFObject(\"CheckBox\")*", UserStatus, "CheckBox");
    AmazonCommonFuncs.clickBtnByName("Save");
    Delay(3000);
    AmazonCommonFuncs.clickOkPopup();
    Delay(3000);
    var verifyDataIntable = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", UName, "User Status", "ACTIVE");
    if (SysAdminCommonFuncs.verifyUserList() && verifyDataIntable) {
        Log.Message("User Created ");
        return true;
    } else {
        Log.Message("User Not Created ");
        return false;
    }
}

function verifyChangePasswordScreen(oldPwd, newPwd, pwdConfirm, securityQuestion, securityAnswer){
    
     var oldPwdverify = verifyBelowLabel("Old Password", oldPwd, "PasswordBox");
     var newPwdverify = verifyBelowLabel("New Password", newPwd, "PasswordBox");
     var confirmPwdverify = verifyBelowLabel("Password Confirmation", pwdConfirm, "PasswordBox");
     var securityQuverify = verifyBelowLabel("Security Question", securityQuestion, "TextBox");
     var securityAnsverify = verifyBelowLabel("Answer to Security Question", securityAnswer, "TextBox");
     if(oldPwdverify && newPwdverify && confirmPwdverify && securityQuverify && securityAnsverify)
      return true;
      else 
      return false;
      
    function verifyBelowLabel(LabelTxt, valueToVerify,elementType){
        try {
          PropArray = new Array("ClrClassName","WPFControlText"); 
          ValuesArray = new Array("Label",LabelTxt); 
          var labelTxt = CommonVars.page.Find(PropArray, ValuesArray, 100);
          var txtBoxObj = labelTxt.Parent.FindChild("ClrClassName", elementType )
          if(txtBoxObj.VisibleOnScreen)
          return true;
          } catch (e) {
          Log.Warning("verifyChangePasswordScreen() catch error, " + e.description);
          return false
          }
        }
}

function ChangePassword(oldPwd, newPwd, pwdConfirm, securityQuestion, securityAnswer, saveData){
      
     //CommonVars.page = Sys.Process("TissueDissection.UI"); 
     enterbelowLabel("Old Password", oldPwd, "PasswordBox");
     enterbelowLabel("New Password", newPwd, "PasswordBox");
     enterbelowLabel("Password Confirmation", pwdConfirm, "PasswordBox");
     enterbelowLabel("Security Question", securityQuestion, "TextBox");
     enterbelowLabel("Answer to Security Question", securityAnswer, "TextBox");
     if(saveData==undefined)
     AmazonCommonFuncs.clickBtnByName("Save");Delay(wait_time);

     //this function is required only for 1 screen, hence not adding in any common functions
     function enterbelowLabel(LabelTxt, valueToEnter,elementType){      
        try {
        Page = CommonVars.page; 
        PropArray = new Array("ClrClassName","WPFControlText"); 
        ValuesArray = new Array("Label",LabelTxt); 
        var labelTxt = Page.Find(PropArray, ValuesArray, 100);
        var txtBoxObj = labelTxt.Parent.FindChild("ClrClassName", elementType )
        txtBoxObj.Keys(valueToEnter);
        } catch (e) {
        Log.Warning("enterbelowLabel() catch error, " + e.description);
        return false
        }        
    }
}

function verifyDropDown(dropdownName, dropdownValue){
try {
        Page = CommonVars.page; 
        PropArray = new Array("ClrClassName","Name"); 
        ValuesArray = new Array("ComboBox",dropdownName); 
        var ddObj = Page.Find(PropArray, ValuesArray, 100);
        for(icnt= 0; icnt<ddObj.wItemCount; icnt++){
          if(ddObj.Items.Item(icnt).Name == dropdownValue){
              Log.Message("Did not find the dropdownvalue " + dropdownValue);
              return true;
            }
        }
        Log.Message("Did not find the dropdown value || " + dropdownValue);
        
    } catch (e) {
        Log.Warning("verifyDropDown() catch error, " + e.description);
        return false
    }

}

function findObjByClassName(clrClassName){
  try{
  var clrObj = CommonVars.page.Find(["ClrClassName"], [clrClassName], _depth);
	if (clrObj) 
    return clrObj;
  else 
    return false;
     }catch( e){
      Log.Message("findObjByClassName() Error"+e.description); 
    }
}

function clickchildObjByClassName(parentObj, clrClassName){
  try{
  var clrChildObj = parentObj.FindChild(["ClrClassName"], [clrClassName], _depth);
	if (clrChildObj){
      clrChildObj.Click();
      return clrChildObj;
    }else 
      return false;
    }catch( e){
      Log.Message("clickchildObjByClassName() Error"+e.description); 
    }
}

function popupObjVerify(clrClassName, wpfTxt){
try{
    var parentObj = Sys.Process("TissueDissection.UI").WPFObject("HwndSource: PopupRoot", "");
    var childObj = parentObj.FindChild(["ClrClassName","WPFControlText"], [clrClassName,wpfTxt], _depth);
    	if (childObj.VisibleOnScreen) 
          return true;
      else 
          return false;
    }catch( e){
      Log.Message("popupObjVerify() Error"+e.description); 
    }
}
function popupObjClick(clrClassName, wpfTxt){
try{
    var parentObj = Sys.Process("TissueDissection.UI").WPFObject("HwndSource: PopupRoot", "");
    var childObj = parentObj.FindChild(["ClrClassName","WPFControlText"], [clrClassName,wpfTxt], _depth);
    	if (childObj.VisibleOnScreen) {
          childObj.Click();
          return true;
      }else 
          return false;
    }catch( e){
      Log.Message("popupObjVerify() Error"+e.description); 
    }
}
function enterLabelNearText(LabelClassname, LabelName, valuetoEnter, elementtype) {
    try {
        Page = CommonVars.page;
        switch (aqString.ToUpper(elementtype)) {
            case "TEXTBOX":
            case "TEXTAREA":
                PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(LabelClassname, LabelName);
                var objLabelName = Page.Find(PropArray, ValuesArray, _depth);
                if (objLabelName) {
                    {
                        objLabelName.HoverMouse();
                        objLabelName.Keys("^a[BS]");
                        objLabelName.Keys(valuetoEnter);
                    }
                }
                if (objLabelName.wText == valuetoEnter) {
                    return true;
                } else {
                    return false;
                }
                break;
            case "CHECKBOX":
                PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(LabelClassname, LabelName);
                var checkBoxobj = Page.Find(PropArray, ValuesArray, _depth);
                if (checkBoxobj.IsChecked == false && valuetoEnter == "Checked") {
                    checkBoxobj.click(3, 3);
                } else if (checkBoxobj.IsChecked == true && valuetoEnter == "Unchecked") {
                    checkBoxobj.click(3, 3);
                } else {
                    Log.Message("did not click on the checkbox either the value is true or the object not found")
                }
                break;
            case "COMBOBOX":
                PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(LabelClassname, LabelName);
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                if (comboboxelement) {
                    comboboxelement.Click();
                  PropArray = new Array("ClrClassName", "WPFControlText");
                  ValuesArray = new Array("TextBlock", valuetoEnter);
                  objValue = Page.Find(PropArray,ValuesArray,_depth);
                  objValue.HoverMouse();
                    objValue.Click();
                 if(comboboxelement.wText==valuetoEnter){
                   Log.Message(valuetoEnter+"is Selected");
                    return true;
                      }else{
                     Log.Message(valuetoEnter+"is not Selected");
                    }
                    }else{
                    Log.Message(comboboxelement + "Not found");
                    return false;
                }
                break;
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(elementType, LabelName);

                break;
            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch


    } catch (e) {
        Log.Message("enterTextNearLabel() Error" + e.description);
    }
}

/************************/

function enterTextNearLabeldoubleParent(LabelText, ValueToEnter, elementType) {
    try {
        var Page = CommonVars.page;

        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                var Labelpar = Labelobj.Parent.Parent;
                //var Labeltxt = Labelpar.Findchild ();
               // var NameObj = "WPFObject(\"TextBox\")";
                if (Labelpar) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array(elementType);
                    var txtBoxobj = Labelpar.FindChild(PropArray, ValuesArray, _depth);
                    if (txtBoxobj) {
                        txtBoxobj.SetText(ValueToEnter);
                    }
                }
                if (txtBoxobj.wText == ValueToEnter) {
                    return true;
                } else {
                    return false;
                }
                break;
            case "PASSWORDBOX":
                PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(elementType, "WPFObject(\"" + LabelText + "\")");
                var pwdBoxobj = Page.Find(PropArray, ValuesArray, _depth);
                if (pwdBoxobj) {
                    pwdBoxobj.Clear();
                    pwdBoxobj.Keys(ValueToEnter);
                }
                break;
            case "CHECKBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, LabelText);
                var checkBoxobj = Page.Find(PropArray, ValuesArray, _depth);
                if (checkBoxobj.IsChecked == false && ValueToEnter == "Checked") {
                    checkBoxobj.click(3, 3);
                } else if (checkBoxobj.IsChecked == true && ValueToEnter == "Unchecked") {
                    checkBoxobj.click(3, 3);
                } else {
                    Log.Message("did not click on the checkbox either the value is true or the object not found")
                }
                break;
            case "DROPDOWN":
            case "COMBOBOX":
            case "SELECT":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                var Labelpar = Labelobj.Parent;
                //var Labeltxt = Labelpar.Findchild ();
               // var NameObj = "WPFObject(\"TextBox\")";
                if (Labelpar) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array(elementType);
                    var comboboxelement = Labelpar.FindChild(PropArray, ValuesArray, _depth);
		              }
               /**** PropArray = new Array("ClrClassName", "Name");
                ValuesArray = new Array(elementType, "WPFObject(\"" + LabelText + "\")");
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                ***/
                if (comboboxelement) {
                comboboxelement.click();
                    for (i = 0; i < comboboxelement.wItemCount - 1; i++) 
                    {   
                        comboboxelement.set_SelectedIndex(i);
                        if (comboboxelement.Keys == ValueToEnter)
                            break;
                        else
                            Log.Message("Not Found in the index" + i)
                    }
                }

                break;
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                var Labelpar = Labelobj.Parent;
                if (Labelpar) {
                    PropArray = new Array("ClrClassName","WPFControlText");
                    ValuesArray = new Array(elementType,ValueToEnter);
                    var txtBoxobj = Labelpar.FindChild(PropArray, ValuesArray, _depth);
                    if (txtBoxobj) {
                        txtBoxobj.Click();
                    }
                }
                if (txtBoxobj.IsChecked) {
                    return true;
                } else {
                    return false;
                }
                break;
               case "DECIMALUPDOWN":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                var Labelpar = Labelobj.Parent;
                if (Labelpar) {
                    PropArray = new Array("ClrClassName","WPFControlIndex");
                    ValuesArray = new Array(elementType,"1");
                    var txtBoxobj = Labelpar.FindChildEx(PropArray, ValuesArray, _depth);
                    txtBoxobj.HoverMouse();
                    txtBoxobj.Click();
                    txtBoxobj.Keys("^a[BS]");
                    txtBoxobj.Keys (ValueToEnter);
                     }
                if (txtBoxobj.VisibleOnScreen) {
                    return true;
                } else {
                    return false;
                }
                break;
            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("enterTextNearLabel() Error" + e.description);
    }
}
/*********************************************************************/
function selectSlide(SlideNo) {
    try {
                var Page = CommonVars.page;
                PropArray = new Array("ClrClassName", "WPFControlIndex");
                ValuesArray = new Array("ListBoxItem", SlideNo);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                    if (Labelobj) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array("Image");
                    var imageobj = Labelobj.FindChildEx(PropArray, ValuesArray, _depth);
                    var objClick = imageobj.Click();
                    }
                    if (Labelobj.IsFocused == true)
                    {
                    return true;
                    Log.Message(SlideNo + "was clicked");
                  }
                     else {
                    Log.Error("Object not found");
                    }
                }

     catch (e) {
        Log.Message("selectSlide() Error" + e.description);
               }
}

/*************************************************************/

function VerifyFields(LabelText,elementType,ValueToFind) {
    try {
        var Page = CommonVars.page;

        switch (aqString.ToUpper(elementType)) {

            case "TEXTBLOCK":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                if (Labelobj) {
                Log.Message(LabelText + ": Was avaliable");
                return true;
                    } else {
                    return false;
                    }
           
            case "CHECKBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TEXTBLOCK", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                if (Labelobj) 
                var Labelpar = Labelobj.Parent;
                if (Labelpar) {
                    PropArray = new Array("ClrClassName","IsChecked");
                    ValuesArray = new Array(elementType,ValueToFind);
                    var txtBoxobj = Labelpar.FindChild(PropArray, ValuesArray, _depth);
                    }
                if (txtBoxobj){
                Log.Message(LabelText + elementType + ValueToFind + ": Was avaliable");
                    return true;
                    } else {
                    return false;
                    }
                    break;
            
            case "RADIOBUTTON":
            case "SELECT":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TEXTBLOCK", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                if (Labelobj) 
                var Labelpar = Labelobj.Parent;
                if (Labelpar) {
                    PropArray = new Array("ClrClassName","WPFControlText");
                    ValuesArray = new Array(elementType,ValueToFind);
                    var txtBoxobj = Labelpar.FindChild(PropArray, ValuesArray, _depth);
                    }
                if (txtBoxobj){
                Log.Message(LabelText + elementType + ValueToFind + ": Was avaliable");
                    return true;
                    } else {
                    return false;
                    }
                    break;
               case "COMBOBOX":
               case "PASSWORDBOX":
               case "TEXTBOX":
               case "TEXTAREA":
               case "DROPDOWN":
               case "SLIDER":
               case "IMAGE":
               case "DECIMALUPDOWN":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TEXTBLOCK", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                if (Labelobj) 
                var Labelpar = Labelobj.Parent;
                if (Labelpar) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array(elementType);
                    var txtBoxobj = Labelpar.FindChildEx(PropArray, ValuesArray, _depth);
                    }
                if (txtBoxobj){
                Log.Message(LabelText + elementType + ": Was avaliable");
                    return true;
                    } else {
                    return false;
                    }
               
                break;
            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("enterTextNearLabel() Error" + e.description);
    }
}

/***********************************************************
Verify Table -Columns header
***********************************************************/
function VerifyTableColumns(tableIDstr, ColumnName) {
    try {
        Page = CommonVars.page;
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        if (tblObj){        
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", ColumnName]);
            if (columnHeaderObj.exists){
            Log.Message(ColumnName + ": Was avaliable");
            return true;
            }
            else
            Log.Message(ColumnName + ": Was not avaliable");
            return false;
         }
     }
       catch (e) {
        Log.Warning("VerifyTableColumns() catch error, " + e.description);
        return false
    }
}
    
