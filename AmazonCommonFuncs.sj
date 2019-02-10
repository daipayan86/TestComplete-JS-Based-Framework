//USEUNIT Library
//USEUNIT CommonFuncs
//USEUNIT SysAdminCommonFuncs
/*******************************************************************************
[Purpose]
Load/Launch the Application 
Ex: LoadApplication
********************************************************************************/
function LoadApplication(AppplicationName) {

    try {

        TestApp1 = TestedApps.Items(AppplicationName);
        // Enables the "Launch" parameter for the tested applications
        TestApp1.Launch = true;
        // Launches the tested applications
        TestApp1.Run();
        Delay(wait_time_long);
        //Delay(wait_time);

        if (!Sys.WaitProcess("TissueDissection.UI").Exists)
            Log.Warning("The specified process does not exist.");
        /*        else if (Sys.Process("TissueDissection.UI").Window("#32770", "Uncaught Thread Exception : dispatcherUnhandledExceptionEventArgs", 1).Window("Button", "OK", 1).Exists){
                Log.Error("The application failed to launch and some Error is stoping the Execution.");
                Runner.Stop();
                }
        */
        else
            CommonVars.page = Sys.Process("TissueDissection.UI");
        var objLandingPage = page.Find("ClrFullClassName", "TissueDissection.UI.Views.Login", _depth);
        if (objLandingPage != null) {
            return true;
        } else {
            return false;
        }
    } catch (e) {
        Log.Warning("LoadApplication() catch error, " + e.description);
        return false
    }

}


/*******************************************************************************
[Purpose]
Login into the Tissue Dissection application
Ex: login("admin","admin")
********************************************************************************/
function login(username, password) {
    try {
        var Page = CommonVars.page;
        var uname_input = Page.Find("Name", "WPFObject(\"txtUserName\")", _depth);
        // uname_input.HoverMouse();
        uname_input.ClickM();
        uname_input.Keys(username);
        var pass_input = Page.Find("Name", "WPFObject(\"txtPasswordBox\")", _depth);
        // pass_input.HoverMouse();
        pass_input.Keys(password);
        AmazonCommonFuncs.clickBtnByName("Login");
        Delay(wait_time);
        if (VerifyNotificationWindow("User Name or Password is invalid. Please retry again.")) {
            ClickNotificationWindow("OK");
            Log.Message(("User Name or Password is invalid. Please retry again."));
            return false;
        } else
            //Delay(wait_time_long);
            //is navigated successfully
            Delay(wait_time);
        ClickNotificationWindow1("OK", "PopupActionWindow");
        Delay(wait_time_very_long);
        ClickNotificationWindow1("OK", "PopupActionWindow");
        Delay(wait_time_very_long);
        ClickNotificationWindow1("OK", "HwndSource");
        Delay(wait_time_very_long);
        var objNewJob = verifyBtnByName("New Job");
        if (objNewJob) {
            return true;
        } else {
            Log.Message("Could not Login to the application Unexpected error.");
            return false;
        }
    } catch (e) {
        Log.Warning("login() catch error, " + e.description);
        return false;
    }

}
/*********************************************************************
[Purpose]
Verifies the Landing page.
Created By: Janardhana.
*******************************************************************************/
function verifyLandingPage() {
    try {
        var Page = CommonVars.page;
        var objLandingPage = Page.Find("ClrFullClassName", "TissueDissection.UI.Views.Login", _depth);
        var objLoginBtn = AmazonCommonFuncs.verifyBtnByName("Login");
        if (objLandingPage != null && objLoginBtn) {
            Log.Message("Login Page is Opened");
            return true;
        } else {
            Log.Message("Login Page is not Opened");
            return false;
        }
    } catch (e) {
        Log.Warning("verifyLandingPage() catch error, " + e.description);
        return false
    }

}

/*******************************************************************************
[Purpose]
Clicks the Button by Name/WPFControltext
Ex: clickBtnByName("New Job")
********************************************************************************/
function clickBtnByName(BtnName) {
    try {
        var Page = CommonVars.page;
        var objBtn = Page.Find(["ClrClassName", "WPFControlText", "VisibleOnScreen"], ["Button", BtnName, "True"], _depth);
        if (objBtn.Exists) {
            objBtn.HoverMouse();
            objBtn.Click();
            Delay(wait_time);
            return true;
        } else {
            Log.Message(BtnName + ": Was not avaliable");
            return false;
        }
    } catch (e) {
        Log.Warning("clickBtnByName() catch error", +e.description);
        return false;
    }
}
/*******************************************************************************
[Purpose]
verify the Button by Name/WPFControltext
Ex: verifyBtnByName("Save")
********************************************************************************/
function verifyBtnByName(BtnName) {
    try {
        var Page = CommonVars.page;
        var objBtn = Page.Find(["ClrClassName", "Content", "VisibleOnScreen"], ["Button", BtnName, "True"], _depth);
        if (objBtn.Exists) {
            //objBtn.HoverMouse();
            //Delay(wait_time);
            Log.Message(BtnName + ": Was avaliable");
            return true;
        } else {
            Log.Message(BtnName + ": Was not avaliable");
            return false;
        }
    } catch (e) {
        Log.Warning("verifyBtnByName() catch error", +e.description);
        return false;
    }
}

/*******************************************************************************
[Purpose]
Close the Application if its already opened
Created : 
********************************************************************************/
function CloseApplicaton(AppplicationName) {
    if (Sys.Process("TissueDissection.UI").Exists)
        Sys.Process("TissueDissection.UI").Terminate();
}


/*******************************************************************************
[Purpose]
Verify Popup/ Notification Window
********************************************************************************/
function VerifyNotificationWindow1(action) {
    try {
        PropArray = new Array("ClrClassName");
        ValuesArray = new Array("HwndSource");
        var notificationwindow = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {

            PropArray = new Array("ClrClassName", "Content");
            ValuesArray = new Array("Button", action);
            var notificationwindowOkBtn = CommonVars.page.Find(PropArray, ValuesArray, _depth);
            if (notificationwindowOkBtn.Exists) {
                Log.Message("Required Window is opened");
                return true;
            } else {
                Log.Message("Required Window is not opened");
                return false;
            }
        } else {
            Log.Message("Object not found");
            return false;
        }

    } catch (e) {
        Log.Message("VerifyNotificationWindow1() Error" + e.description);
    }
}

/*******************************************************************************
[Purpose]
Verify Button Disabled
Ex:verifyButtonDisabled("Save");
********************************************************************************/

function verifyButtonDisabled(BtnName) {
    try {
        PropArray = new Array("ClrClassName", "Content", "VisibleOnScreen");
        ValuesArray = new Array("Button", BtnName, "True");
        var BtnObj = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        if (BtnObj.IsEnabled == false){
        Log.Message(BtnName + " is Disabled");
            return true;
        }else {
        Log.Message(BtnName + " is Enabled");
            return false;
            }
    } catch (e) {
        Log.Message("verifyButtonDisabled() Error" + e.description)
    }
}
/*******************************************************************************
[Purpose]
Verify Notification Window Message
Ex: VerifyNotificationWindow("User Name or Password is invalid. Please retry again.",true)
********************************************************************************/
function VerifyNotificationWindow(ContentText, ifContains) {
    var ifContains = false || ifContains
    try {
        PropArray = new Array("ClrClassName");
        ValuesArray = new Array("DefaultNotificationWindow");
        var notificationwindow = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {
            if (ifContains) {
                PropArray = new Array("ClrClassName", "VisibleOnScreen");
                ValuesArray = new Array("ContentControl", "True");
                var notificationwindowOkBtn = CommonVars.page.Find(PropArray, ValuesArray, _depth);
                if (aqString.Find(notificationwindowOkBtn.WPFControlText, ContentText) != -1) {
                    Log.Message("Substring '" + ContentText + "' was found in string '");
                    return true;
                } else {
                    Log.Message("Substring '" + ContentText + "' was NOT found in string '");
                    return false;
                }
            } else {
                PropArray = new Array("ClrClassName", "Content");
                ValuesArray = new Array("ContentControl", ContentText);
                var notificationwindowOkBtn = CommonVars.page.Find(PropArray, ValuesArray, _depth);
                if (notificationwindowOkBtn.Exists) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    } catch (e) {
        Log.Message("VerifyNotificationWindow() Error" + e.description);
    }
}


/*******************************************************************************
[Purpose]
find a data in the table to verify
Usage Example
TableDataVerify("WPFObject(\"dgUsers\")", "User Name", "admin", "User Status", "ACTIVE");
********************************************************************************/

function TableDataVerify(tableIDstr, compareColumnName, compareValue, columnToVerify, valueToVerify) {

    var columnIndextoCompare, columnIndextoverify, RowMatchedData;
    //var tableMapID = idStrMap('Table', tableIDstr);
    try {
        Page = CommonVars.page;
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = tblObj.wRowCount;

        if (RowCount > 0) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "WPFControlText"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj.Exists) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "WPFControlText"], ["DataGridColumnHeader", columnToVerify]);
            if (columnHeaderObj.Exists) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }
        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj.Exists) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }
        var dataVerifyObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        var dataCellObj = dataVerifyObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", valueToVerify, columnIndextoverify], 200);
        if (dataCellObj.Exists)
            return true;
        else
            return false;
    } catch (e) {
        Log.Warning("TableDataVerify() catch error, " + e.description);
        return false
    }
}


/*******************************************************************************
[Purpose]
find a data in the table to verify
Usage Example
TableDataModify("WPFObject(\"dgUsers\")", "User Name", "admin", "User Status", "ACTIVE");
********************************************************************************/

function TableDataModify(tableIDstr, compareColumnName, compareValue, columnToModify, valueToModify) {

    var columnIndextoCompare, columnIndextoverify, RowMatchedData, columnIndex;
    //var tableMapID = idStrMap('Table', tableIDstr);
    try {
        Page = CommonVars.page || Sys.Process("TissueDissection.UI");
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = totalChildCount - (tblColCount - 1);

        if (RowCount > 1) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", columnToModify]);
            if (columnHeaderObj) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }

        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }

        var dataRowObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        if (typeof(columnIndextoverify) == "number")
            columnIndex = tblColCount;
        var dataCellObj = dataRowObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridCell", columnIndex], 200);
        var datacellButtonObj = dataCellObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["Button", 1], 200);
        if (datacellButtonObj.Exists) {
            datacellButtonObj.HoverMouse();
            datacellButtonObj.click();
            AmazonCommonFuncs.enterTextNearLabel("Name", valueToModify, "TextBox");
            AmazonCommonFuncs.clickBtnByName("Save");
            var objpopupMessage = ClickNotificationWindow1("OK", "HwndSource");
            if (objpopupMessage)
                return true;
            else
                return false;
        } 
    } catch (e) {
        Log.Warning("TableDataModify() catch error, " + e.description);
        return false
    }
}

/*********************************
[Purpose]
Click Button on the Notification Window.
Ex: ClickNotificationWindow1("OK","HwndSource")
********************************/
function ClickNotificationWindow1(action, ClassName) {
    try {
        PropArray = new Array("ClrClassName");
        ValuesArray = new Array(ClassName);
        var notificationwindow = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {
            PropArray = new Array("ClrClassName", "Content", "VisibleOnScreen");
            ValuesArray = new Array("Button", action, "True");
            var notificationwindowOkBtn = CommonVars.page.Find(PropArray, ValuesArray, _depth);
            if (notificationwindowOkBtn.Exists) {
                notificationwindowOkBtn.HoverMouse();
                notificationwindowOkBtn.Click();
                return true;
            }
        }


    } catch (e) {
        Log.Message("ClickNotificationWindow1() Error" + e.description);
    }
}


//----------------

function Get_element_textarea(str, valuetoEnter, NameofField) {
    PropArray = new Array("ClrClassName", "WPFControlText");
    ValuesArray = new Array("TextBlock", str);

    obj = Find_object_with_timeout(PropArray, ValuesArray, _depth);

    if (obj.Exists) {
        Log.Message("TextNode element: '" + str + "' Found.");
        obj.HoverMouse();
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("TextBox", "WPFObject(\"" + NameofField + "\")");
        obj = Find_object_with_timeout(PropArray, ValuesArray, _depth);
        if (obj.Exists)
            Log.Message("TextNode element: '" + NameofField + "' Found.");

        else
            Log.Warning("Object not found.");

    } else {
        Log.Warning("TextNode element: '" + str + "' not exists.");
        obj = null;
    }
    return obj;

}
/******************************************************************************
[Purpose]
Select the menu item from the user drop down
Ex: MenuNavigate("Job List"),MenuNavigate("Log Out")
*********************************************************************************/
function MenuNavigate(MenuItem) {
    try {
        CommonVars.page = Sys.Process("TissueDissection.UI");
        var Page = CommonVars.page;
        PropArray = new Array("Name");
        ValuesArray = new Array("WPFObject(\"userNameText\")");
        menuObj = Page.Find(PropArray, ValuesArray, _depth);
        if (menuObj.Exists){
            menuObj.HoverMouse();
        menuObj.Click();
        }else{
        return false;
        }
        switch (MenuItem) {
            case "Log Out":
                // click Logout 
                Log.Message("Clicking Logout...");
                Sys.Keys("[Down][Down][Down][Down], [Enter]");
                Log.Message("User Logged out successfully");
                Delay(wait_time);
                var objLoginScreen = CommonVars.page.Find("Name", "WPFObject(\"btnLogin\")", _depth);
                if (objLoginScreen.VisibleOnScreen == true) {
                    Log.Message("Login page has been loaded after logout");
                    return true;
                } else {
                    Log.Message("Login page NOT loaded after logout");
                    return false;
                }
                break;
                //click Job list.
            case "Job List":
                Log.Message("Clicking Job List...");
                Sys.Keys("[Down], [Enter]");
                var objNewJobBtn = AmazonCommonFuncs.verifyBtnByName("New Job");
                if(objNewJobBtn){
                Log.Message("JobList page has been Opened");
                    return true;
                } else {
                    Log.Message("JobList page has not Opened");
                    return false;
                }
                break;
            case "Calibration":
                //click on Calibration
                Log.Message("Clicking Calibration...");
                Sys.Keys("[Down][Down][Down], [Enter]");
                break;
            case "Administration":
                //click on Administration
                Log.Message("Clicking Administration.....");
                Sys.Keys("[Down][Down], [Enter]");
                var objMyAccountScreen = CommonVars.page.Find("WPFControlText", "My Account", _depth);
                if (objMyAccountScreen.VisibleOnScreen == true) {
                    Log.Message("Administration page has been loaded");
                    return true;
                } else {
                    Log.Message("Administration page NOT loaded");
                    return false;
                }
                break;
            default:
                Log.Message(MenuItem + " not found");
        } //end of Switch

    } catch (e) {
        Log.Message("MenuNavigate() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Select the Adminitration menuitems
Ex: ClickMenuitem("User Management"),ClickMenuitem("Tissue Options")
Created: Janardhana
**********************************************************************/
function ClickMenuitem(Menuitem) {
    try {
        CommonVars.page = Sys.Process("TissueDissection.UI");
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TabItem", Menuitem);
        var objsubmenuitems = Page.Find(PropArray, ValuesArray, _depth);
        if (objsubmenuitems.WPFControlText == Menuitem) {
            objsubmenuitems.HoverMouse();
            objsubmenuitems.Click();
            Delay(wait_time);
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("TextBlock", Menuitem);
            var objPageverify = Page.Find(PropArray, ValuesArray, _depth);
            if (objPageverify) {
                Log.Message(Menuitem + "page is opened");
                return true;
            } else {
                Log.Message(Menuitem + "page is not opened");
            }
        } else {
            Log.Message(Menuitem + "Not Clicked");
            return false;
        }
    } catch (e) {
        Log.Warning("ClickMenuitem() catch error, " + e.description);
    }
}
//============================================================
//Function not using in any scripts
function dropdown(clrclassname, LabelName, valuetoEnter) {
    try {
        CommonVars.page = Sys.Process("TissueDissection.UI");
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array(clrclassname, LabelName);
        objGender = Page.Find(PropArray, ValuesArray, _depth);
        if (objGender.Exists) {
            objGender.Click();
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("TextBlock", valuetoEnter);
            objValue = Page.Find(PropArray, ValuesArray, _depth);
            objValue.HoverMouse();
            objValue.Click();
            if (objGender.wText == valuetoEnter) {
                Log.Message(valuetoEnter + "is Selected");
                return true;
            } else {
                Log.Message(valuetoEnter + "is not Selected");

            }
        } else {
            Log.Message("Object not identified");
            return false;
        }
    } catch (e) {
        Log.Warning("dropdown() catch error, " + e.description);
        return false;
    }

}
/********************************************************************
[Purpose]
Creates the Tissue under the Tissue options page
Ex: createTissueType("Breast")
Created: Daipayan Sarkar
**********************************************************************/
function createNewTissueType(TissutypeName, TissutypeDes) {
    try {
        AmazonCommonFuncs.enterTextNearLabel("Name", TissutypeName, "TextBox");
        AmazonCommonFuncs.enterTextNearLabel("Description", TissutypeDes, "TextBox");
        AmazonCommonFuncs.clickBtnByName("Save");
        AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
        Delay(3000);
        var objTissueVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"DgTissueType\")", "Name", TissutypeName, "Status", "ACTIVE");
        if (objTissueVerify) {
            Log.Message(TissutypeName + "is created");
            return true;
        } else {
            Log.Message(TissutypeName + "is not created");
            return false;
        }
    } catch (e) {
        Log.Warning("createNewTissueType() catch error, " + e.description);
        return false;
    }
}
/********************************************************************
[Purpose]
Selects the tab and verifies
Ex: selectTabAndVerify("TissueType","Add Tissue Type")
**********************************************************************/
function selectTabAndVerify(Tabname, BtnName) {
    try {
        CommonVars.page = Sys.Process("TissueDissection.UI");
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TabItem", Tabname);
        objTabName = Page.Find(PropArray, ValuesArray, _depth);
        if (objTabName.Exists) {
            objTabName.HoverMouse();
            objTabName.Click();
            var objVerifyTab = AmazonCommonFuncs.verifyBtnByName(BtnName);
            if (objVerifyTab) {
                Log.Message(Tabname + "is opened Successfully");
                return true;
            } else {
                Log.Message(Tabname + "is not opened Successfully");
            }
        } else {
            Log.Message(objTabName + "Not identified");
        }
    } catch (e) {
        Log.Warning("selectTabAndVerify() catch error, " + e.description);
        return false;
    }
}
/********************************************************************
[Purpose]
Creates the Downstream application
Ex: createDownStream("DownStreamName","DownStreamDes")
**********************************************************************/
function createDownStream(DownStreamName, DownStreamDes) {
    try {

        AmazonCommonFuncs.enterTextNearLabel("Name", DownStreamName, "TextBox");
        AmazonCommonFuncs.enterTextNearLabel("Description", DownStreamDes, "TextBox");
        AmazonCommonFuncs.clickBtnByName("Save");
        AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
        Delay(3000);
        var objDownStreamVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"DgDownstream\")", "Name", DownStreamName, "Status", "Active");
        if (objDownStreamVerify) {
            Log.Message(DownStreamName + "is created");
            return true;
        } else {
            Log.Message(DownStreamName + "is not created");
        }
    } catch (e) {
        Log.Warning("createDownStream() catch error, " + e.description);
        return false;
    }
}
/********************************************************************
[Purpose]
Creates the Target Volumes
Ex: createTargetVolumes("TissueTypeName","DownStreamName",200)
**********************************************************************/
function createTargetVolumes(TissueType, DownStream, Targetvolume) {
    try {

        var Page = CommonVars.page;
        AmazonCommonFuncs.EnterAnyText("Tissue Type", TissueType, "ComboBox");
        AmazonCommonFuncs.EnterAnyText("Downstream Application", DownStream, "ComboBox");
        PropArray = new Array("ClrClassName", "Visible");
        ValuesArray = new Array("TextBox", "True");
        txtBoxobj = page.Find(PropArray, ValuesArray, _depth);
        if (txtBoxobj) {
            txtBoxobj.HoverMouse();
            txtBoxobj.Keys("^a[BS]");
            txtBoxobj.Keys(Targetvolume);
        }
        //AmazonCommonFuncs.EnterAnyText("WPFObject(\"TextBox\")", "100", "TextBox");
        AmazonCommonFuncs.clickBtnByName("Save");
        AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
        Delay(3000);
        var objTargetVolVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"DgTargetVolume\")", "Tissue Type", TissueType, "Target Volume", Targetvolume);
        if (objTargetVolVerify) {
            Log.Message(Targetvolume + "is created");
            return true;
        } else {
            Log.Message(Targetvolume + "is not created");
        }
    } catch (e) {
        Log.Warning("createTargetVolumes() catch error, " + e.description);
        return false;
    }
}

/********************************************************************
[Purpose]
Edits the Target Volumes
Ex: EditTargetVolume("Name","TissueType","Target Volume",300)
**********************************************************************/

function EditTargetVolume(compareColumnName, compareValue, columnToModify, valueToModify) {
    var columnIndextoCompare, columnIndextoverify, RowMatchedData, columnIndex;
    try {
        Page = CommonVars.page || Sys.Process("TissueDissection.UI");
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array("WPFObject(\"DgTargetVolume\")", "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = totalChildCount - (tblColCount - 1);

        if (RowCount > 1) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", columnToModify]);
            if (columnHeaderObj) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }

        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }

        var dataRowObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        if (typeof(columnIndextoverify) == "number")
            columnIndex = tblColCount;
        var dataCellObj = dataRowObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridCell", columnIndex], 200);
        var datacellButtonObj = dataCellObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["Button", 1], 200);
        if (datacellButtonObj) {
            datacellButtonObj.HoverMouse();
            datacellButtonObj.click();
            PropArray = new Array("ClrClassName", "Visible");
            ValuesArray = new Array("TextBox", "True");
            txtBoxobj = page.Find(PropArray, ValuesArray, _depth);
            if (txtBoxobj) {
                txtBoxobj.HoverMouse();
                txtBoxobj.Keys("^a[BS]");
                txtBoxobj.Keys(valueToModify);
            }
            AmazonCommonFuncs.clickBtnByName("Save");
            var objTargetedited = AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
            Delay(3000);
        }

        if (objTargetedited) {
            Log.Message(columnToModify + "is edited");
            return true;
        } else {
            Log.Message(columnToModify + "is not edited");
        }
    } catch (e) {
        Log.Warning("EditTargetVolume() catch error, " + e.description);
        return false;
    }
}

//======================================
function verifyEditPage(pageName) {
    try {
        CommonVars.page = Sys.Process("TissueDissection.UI");
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TextBlock", pageName);
        objEditPage = Page.Find(PropArray, ValuesArray, _depth);
        if (objEditPage.Exists) {
            Log.Message(pageName + "Page is opened");
            return true;
        } else {
            Log.Message(pageName + "Page is not opened");
        }
    } catch (e) {
        Log.Warning("verifyEditPage() catch error, " + e.description);
        return false;

    }
}
/********************************************************************
[Purpose]
Enter the text into the Field
Ex: EnterAnyText("User Name","John","TextBox"),EnterAnyText("Password","John","PasswordBox")
**********************************************************************/
function EnterAnyText(NameText, ValueToEnter, elementType) {
    try {
        var Page = CommonVars.page;
        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
            case "DATEPICKER":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    txtBoxobj.HoverMouse();
                    txtBoxobj.Keys("^a[BS]");
                    txtBoxobj.Keys(ValueToEnter);
                } //}
                if (txtBoxobj.wText == ValueToEnter) {
                    return true;
                } else if (txtBoxobj.Text == ValueToEnter) {
                    return true;
                } else {
                    Log.Error("Object not found");
                }
                break;
            case "PASSWORDBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    txtBoxobj.Keys("^a[BS]");
                    txtBoxobj.Keys(ValueToEnter);
                }
            case "CHECKBOX":
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, NameText);
                var objLabel = Page.Find(PropArray, ValuesArray, _depth);
                if (objLabel.Exists) {
                    objLabel.Click();
                    Delay(wait_time_long);
                    return true;
                } else {
                    Log.Message(objLabel + "does not exists");
                    return false;
                }
                break;
            case "COMBOBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                objcomboxelement = comboboxelement.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objcomboxelementclick = objcomboxelement.Find(PropArray, ValuesArray, _depth);
                if (objcomboxelementclick.Exists) {
                    objcomboxelementclick.Click();
                    PropArray = new Array("WPFControlText");
                    ValuesArray = new Array(ValueToEnter);
                    objValue = Page.Find(PropArray, ValuesArray, _depth);
                    //objValue.HoverMouse();
                    objValue.Click();
                    if (objcomboxelementclick.wText == ValueToEnter) {
                        Log.Message(ValueToEnter + "is Selected");
                        return true;
                    } else if (objcomboxelementclick.SelectedValue.Name == ValueToEnter) {
                        Log.Message(ValueToEnter + "is Selected");
                        return true;
                    } else {
                        Log.Message(ValueToEnter + "is not Selected");
                    }
                } else {
                    Log.Message(objcomboxelementclick + "Not found");
                    return false;
                }
                break;
            case "LISTBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                objListBoxLabel = Page.Find(PropArray, ValuesArray, _depth);
                objListBoxPar = objListBoxLabel.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objListBox = objListBoxPar.Find(PropArray, ValuesArray, _depth);
                if (objListBox.Exists) {
                    PropArray = new Array("ClrClassName", "WPFControlText");
                    ValuesArray = new Array("CheckBox", ValueToEnter);
                    objListBoxLabelValue = Page.Find(PropArray, ValuesArray, _depth);
                    if (objListBoxLabelValue)
                        objListBoxLabelValue.HoverMouse();
                    objListBoxLabelValue.Click();
                    if (objListBoxLabelValue.IsChecked == true) {
                        Log.Message(ValueToEnter + "is Checked");
                        return true;
                    } else {
                        Log.Message(ValueToEnter + "is not Checked");
                    }
                } else {
                    Log.Error(objListBox + "Object not found");
                    return false;
                }
                break;
            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("EnterAnyText() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Creates the case and Verifies case is created or not
Ex:createCaseAndVerify("Case001","JOhn","123","Male","Lung","DownStream")
**********************************************************************/
function createCaseAndVerify(casedId, patientName, patientID, Gender, TissueType, DownStreamName) {
    try {
        var Page = CommonVars.page;
        SysAdminCommonFuncs.enterLabelNearText("TextBox", "WPFObject(\"CaseIdTextBox\")", casedId, "TextBox");
        //EnterAnyText("Case ID", casedId, "TextBox");
        EnterAnyText("Patient", patientName, "TextBox");
        EnterAnyText("Patient ID", patientID, "TextBox");
        EnterAnyText("Gender", Gender, "ComboBox");
        //EnterAnyText("Date Of Birth", DateOffBirth, "DatePicker");
        EnterAnyText("Tissue Type", TissueType, "ComboBox");
        EnterAnyText("Downstream Application", DownStreamName, "ListBox");
        AmazonCommonFuncs.clickBtnByName("SCAN STAGE");
        Delay(wait_time_very_long);
        Delay(wait_time_long);
        var objScanStage = AmazonCommonFuncs.verifyScreen();
        if (objScanStage) {
            Log.Message(casedId + " is created and navigated to Stage overview Screen");
            return true;
        } else {
            Log.Message(casedId + " is not created and not navigated to Stage overview Screen");
            return false;
        }
    } catch (e) {
        Log.Message("createCaseAndVerify() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Creates the tissue portion on slide and verifies
Ex:createTissuePortion(90,280,90,170,1)
**********************************************************************/
function createTissuePortion(X0, Y0, X1, Y1, slideNo) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("ListBox", "WPFObject(\"StageList\")");
        var objSlideImage = Page.Find(PropArray, ValuesArray, _depth);
        PropArray = new Array("ClrClassName", "WPFControlIndex");
        ValuesArray = new Array("ListBoxItem", slideNo);
        var objSlideImages = objSlideImage.Find(PropArray, ValuesArray, _depth);
        if (objSlideImages.Exists) {
            if (objSlideImages.WPFControlIndex == slideNo)
                objSlideImages.Click();
            objSlideImages.Drag(X0, Y0, X1, Y1);
            Delay(wait_time_long);
            PropArray = new Array("ClrClassName", "Name");
            ValuesArray = new Array("Rectangle", "*WPFObject(\"Rectangle\")*");
            var objTissuePortion = Page.Find(PropArray, ValuesArray, _depth);
            if (objTissuePortion) {
                Log.Message(objTissuePortion + "Is drawn");
                return true;
            } else {
                Log.Error(objTissuePortion + "Is not drawn");
            }

        } else {
            Log.Message(objSlideImage + "Object does not exists");
            return false;
        }
    } catch (e) {
        Log.Message("createTissuePortion() Error" + e.description);
    }

}
/********************************************************************
[Purpose]
Verifies the Label on screen.
Ex:verifyLabel("FirstName")
**********************************************************************/
function verifyLabel(LabelName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TextBlock", LabelName);
        var objLabel = Page.Find(PropArray, ValuesArray, _depth);
        if (objLabel.Exists) {
            Log.Message(LabelName + "is exists");
            return true;
        } else {
            Log.Message(casedId + "is not exists");
            return false;
        }
    } catch (e) {
        Log.Message("verifyLabel() Error" + e.description);
    }
}

/********************************************************************
[Purpose]
Verifies Error msg displayed when login with the wrong credentials
Ex:invalidLogin("admin","adm");
**********************************************************************/
function invalidLogin(username, password) {
    try {
        var Page = CommonVars.page;
        var uname_input = Page.Find("Name", "WPFObject(\"txtUserName\")", _depth);
        // uname_input.HoverMouse();
        uname_input.ClickM();
        uname_input.Keys(username);
        var pass_input = Page.Find("Name", "WPFObject(\"txtPasswordBox\")", _depth);
        // pass_input.HoverMouse();
        pass_input.Keys(password);
        AmazonCommonFuncs.clickBtnByName("Login");
        Delay(wait_time);
        var objInvalidMsg = VerifyNotificationWindow("Your account has not been approved or is locked. Please contact your system administrator for more information.");
        ClickNotificationWindow1("OK", "HwndSource");
        var objBtnDisabled = verifyButtonDisabled("Login");
        if (objInvalidMsg && objBtnDisabled) {
            Log.Message(("Your account has not been approved or is locked. Please contact your system administrator for more information."));
            return true;
        } else {
            Log.Message("Your account has not been approved or is locked. Please contact your system administrator for more information.");
            return false;
        }
    } catch (e) {
        Log.Message("invalidLogin() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Verifies Error msg displayed when login with the multiple times with wrong credentials
Ex:invalidloginAttempts("admin","adm");
**********************************************************************/
function invalidloginAttempts(username, password) {
    try {
        var Page = CommonVars.page;
        var uname_input = Page.Find("Name", "WPFObject(\"txtUserName\")", _depth);
        // uname_input.HoverMouse();
        uname_input.ClickM();
        uname_input.Keys(username);
        var pass_input = Page.Find("Name", "WPFObject(\"txtPasswordBox\")", _depth);
        // pass_input.HoverMouse();
        pass_input.Keys(password);
        AmazonCommonFuncs.clickBtnByName("Login");
        Delay(wait_time);
        if (VerifyNotificationWindow("User Name or Password is invalid. Please retry again.")) {
            ClickNotificationWindow1("OK", "HwndSource");
            Log.Message(("User Name or Password is invalid. Please retry again."));
            return true;
        } else {
            Log.Message(("User Name or Password is invalid. Please retry again."));
            return false;
        }
    } catch (e) {
        Log.Message("invalidloginAttempts() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Creates the User with Role
Ex:createUser("John","Smith","User123","Testing@123!","Testing@123!","Service")
**********************************************************************/
function createUser(FirstName, LastName, UserName, Password, CofirmPassword, RoleName) {
    try {
        //AmazonCommonFuncs.MenuNavigate("Administration");
        //AmazonCommonFuncs.ClickMenuitem("User Management");
        //clickBtnAndVerifyPage("Create User", "Add User");
        AmazonCommonFuncs.EnterAnyText("First Name    *", FirstName, "TextBox");
        AmazonCommonFuncs.EnterAnyText("Last Name   *", LastName, "TextBox");
        AmazonCommonFuncs.EnterAnyText("User Name   *", UserName, "TextBox");
        AmazonCommonFuncs.EnterAnyText("Password   *", Password, "PasswordBox");
        AmazonCommonFuncs.EnterAnyText("Re-Enter Password   *", CofirmPassword, "PasswordBox");
        AmazonCommonFuncs.EnterAnyText("Role   *", RoleName, "ComboBox");
        AmazonCommonFuncs.clickBtnByName("Save");
        AmazonCommonFuncs.ClickNotificationWindow1("OK", "HwndSource");
        Delay(wait_time_long);
        var objTableDataVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"dgUsers\")", "User Name", UserName, "First Name ", FirstName);
        if (objTableDataVerify) {
            Log.Message(UserName + "Exists in the User List");
            return true;
        } else {
            Log.Message(UserName + "Not Exists in the User List");
            return false;
        }
    } catch (e) {
        Log.Message("createUser() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Click on Btn and verifies the Page is opened
Ex:clickBtnAndVerifyPage("Create User","Add User")
**********************************************************************/
function clickBtnAndVerifyPage(BtnName, PageName) {
    try {
        AmazonCommonFuncs.clickBtnByName(BtnName);
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TextBlock", PageName);
        var objPageName = Page.Find(PropArray, ValuesArray, _depth);
        if (objPageName) {
            Log.Message(PageName + "Page is opened");
            return true;
        } else {
            Log.Message(PageName + "Page is not opened");
            return false;
        }
    } catch (e) {
        Log.Message("clickBtnAndVerifyPage() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Verifies the Particular link is enabled or not
Ex:verifyLinkEnabled("Forgot Password")
**********************************************************************/
function verifyLinkEnabled(LinkName) {
    try {
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TextBlock", LinkName);
        var LinkObj = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        if (LinkObj.IsEnabled == true)
            return true;
        else
            return false;
    } catch (e) {
        Log.Message("verifyLinkEnabled() Error" + e.description)
    }
}
/********************************************************************
[Purpose]
Click on Link
Ex:clickOnLink("Forgot Password")
**********************************************************************/
function clickOnLink(LinkName) {
    //Implementation Pending since it
    try {
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("TextBlock", LinkName);
        var LinkObj = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        if (LinkObj.Exists) {
            Log.Message(LinkObj + "is exists");
            LinkObj.HoverMouse();
            LinkObj.Click();
            return true;
        } else {
            Log.Message(LinkObj + "is not exists");
            return false;
        }
    } catch (e) {
        Log.Message("clickOnLink() Error" + e.description)
    }
}
/********************************************************************
[Purpose]
Changes the Password for the firsttime User
Ex:changePwd("FirsttimeUser","Testing@123!","Testing@123!!","Testing@123!!","Question","Answer")
**********************************************************************/
function changePwd(objUsername, objPassword, objOldPassword, objNewPassword, objNewConfirmPwd, objSecurityQuestion, objSecurityAnswer) {
    try {
        //AmazonCommonFuncs.createUser(objFirstname, objLastname, objUsername, objPassword, objConfirmPwd, objRoleName);
        //AmazonCommonFuncs.MenuNavigate("Log Out");
        //Delay(wait_time);
        var objChangePWDScreen = changePwdLogin(objUsername, objPassword);
        if (objChangePWDScreen) {
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
        }
    } catch (e) {
        Log.Message("changePwd() Error" + e.description);
    }

}

function verifyChangePwdMsg(ContentText, ifContains) {
    var ifContains = false || ifContains
    try {
        var Page = CommonVars.page;
        PropArray = new Array("Name");
        ValuesArray = new Array("Window(*\"#32770*\")");
        var notificationwindow = Page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {
            if (ifContains) {
                PropArray = new Array("Name");
                ValuesArray = new Array("Window(*\"Static*\")");
                var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
                if (aqString.Find(notificationwindowOkBtn.WndCaption, ContentText) != -1) {
                    clickOKOnNotificationWindow();
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

function changePwdLogin(Username, Password) {
    try {
        var Page = CommonVars.page;
        var uname_input = Page.Find("Name", "WPFObject(\"txtUserName\")", _depth);
        // uname_input.HoverMouse();
        uname_input.ClickM();
        uname_input.Keys(Username);
        var pass_input = Page.Find("Name", "WPFObject(\"txtPasswordBox\")", _depth);
        // pass_input.HoverMouse();
        pass_input.Keys(Password);
        AmazonCommonFuncs.clickBtnByName("Login");
        Delay(wait_time);
        PropArray = new Array("ClrClassName");
        ValuesArray = new Array("Grid");
        var objChangePWDScreen = Page.Find(PropArray, ValuesArray, _depth);
        if (objChangePWDScreen) {
            Log.Message(objChangePWDScreen + "is displayed");
            return true;
        } else {
            Log.Message(objChangePWDScreen + "is not displayed");
            return false;
        }
    } catch (e) {
        Log.Message("changePwdLogin() Error" + e.description);
    }
}

function clickOKOnNotificationWindow() {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("Name");
        ValuesArray = new Array("Window(*\"#32770*\")");
        var notificationwindow = Page.Find(PropArray, ValuesArray, _depth);
        if (notificationwindow.Exists) {
            PropArray = new Array("WndClass", "WndCaption");
            ValuesArray = new Array("Button", "OK");
            var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
            if (notificationwindowOkBtn.Exists) {
                notificationwindowOkBtn.Click();
            }
        }
    } catch (e) {
        Log.Message("clickOKOnNotificationWindow() Error" + e.description);
    }
}
/********************************************************************
[Purpose]
Verifies the Label
Ex:VerifyLabelNearText("Name","TextBox"),VerifyLabelNearText("Password","PasswordBox")
**********************************************************************/
function VerifyLabelNearText(NameText, elementType) {
    try {
        var Page = CommonVars.page;
        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
            case "DATEPICKER":
            case "TEXTBLOCK":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    txtBoxobj.HoverMouse();
                    //txtBoxobj.Click();
                    return true;
                } else {
                    Log.Message(elementType + "Not found");
                    return false;
                }
                break;
            case "PASSWORDBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    return true;
                } else {
                    Log.Message(elementType + "Not found");
                    return false;
                }
                break;
            case "CHECKBOX":
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, NameText);
                var checkBoxobj = Page.Find(PropArray, ValuesArray, _depth);
                if (checkBoxobj.Exists) {
                    //checkBoxobj.Click();
                    return true;
                } else {
                    Log.Message("Checkbox not found or its not " + ValueToEnter);
                    return false;
                }
                break;
            case "COMBOBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                objcomboxelement = comboboxelement.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objcomboxelementclick = objcomboxelement.Find(PropArray, ValuesArray, _depth);
                if (objcomboxelementclick.Exists) {
                    objcomboxelementclick.Click();
                    Log.Message(NameText + "is avaliable");
                    return true;
                } else {
                    Log.Message(ValueToEnter + "is not Selected");
                }
                break;
            case "LISTBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                objListBoxLabel = Page.Find(PropArray, ValuesArray, _depth);
                objListBoxPar = objListBoxLabel.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objListBox = objListBoxPar.Find(PropArray, ValuesArray, _depth);
                if (objListBox.Exists) {
                    Log.Message(NameText + "is avalible");
                    return true;
                } else {
                    Log.Message(NameText + "is not avaliable");
                }
                break;
            case "INTEGERUPDOWN":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                objUpAndDown = Page.Find(PropArray, ValuesArray, _depth);
                //var objparent = objUpAndDown.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objUpDown = Page.Find(PropArray, ValuesArray, _depth);
                if (objUpDown.Exists) {
                    return true;
                } else {
                    return false;
                }
                break;
            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("VerifyLabelNearText() Error" + e.description);
    }
}
/***************************************************************
[Purpose]
Search the case and verify case exists or not
Created: Janardhana 
****************************************************************/
function search_Case_verify(caseID, status) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("TextBox", "WPFObject(\"SearchBoxView\")");
        var txtSearchBoxobj = Page.Find(PropArray, ValuesArray, _depth);
        if (txtSearchBoxobj.Exists) {
            txtSearchBoxobj.Click();
            txtSearchBoxobj.Keys("^a[BS]");
            txtSearchBoxobj.Keys(caseID);
            txtSearchBoxobj.Keys("[Enter]");
            Delay(wait_time);
            //var objCaseVerify = AmazonCommonFuncs.TableDataVerify("WPFObject(\"CaselistDataGrid\")","Case ID",caseID,"Status",status);
            var objCaseVerify = AmazonCommonFuncs.caseTableDataVerify("WPFObject(\"CaselistDataGrid\")", "Case ID", caseID, "Status", status);
            //PropArray = new Array("ClrClassName", "Name");
            // ValuesArray = new Array("DataGridRow", "WPFObject(*\"DataGridRow*\")");
            //var txtCaseListObj = Page.Find(PropArray, ValuesArray, _depth);
            //PropArray = new Array("ClrClassName", "WPFControlText");
            //ValuesArray = new Array("TextBlock", caseID);
            //var txtCaseObj = txtCaseListObj.Find(PropArray, ValuesArray, _depth);
            //if (txtCaseListObj.Item.CaseAccessionNumber.OleValue==caseID && txtCaseListObj.Item.Status.OleValue==status) {
            if (objCaseVerify) {
                Log.Message(caseID + "," + "is Exists in the Case List");
                return true;
            } else {
                Log.Message(caseID + "," + "is Exists in the Case List");
                return false;
            }
        } else {
            Log.Message(txtSearchBoxobj + "not exits");
            return false;
        }
    } catch (e) {
        Log.Message("search_Case_verify() Error" + e.description);
    }

}
/********************************************************************
[Purpose]
select and verify the reference image from file or Stage
Ex: select_Image("From Stage") or select_Image("From File")
*********************************************************************/
function select_Image(ImageFile, img) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("RadioButton", ImageFile);
        var txtFile = Page.Find(PropArray, ValuesArray, _depth);
        if (txtFile.IsChecked.OleValue == true) {
            Log.Message(ImageFile + "," + "Radio button is selected");
        } else if (txtFile.IsChecked.OleValue == false) {
            txtFile.Click();
        }
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("Button", "WPFObject(\"ReferenceImageFileSelectButton\")");
        var txtFilePath = Page.Find(PropArray, ValuesArray, _depth);
        if (txtFilePath.Exists)
            txtFilePath.Click();
        Delay(wait_time);
        var ChooseFileToUploadWindow = Page.Window("*", "Select a Reference Image", 1);
        if (ChooseFileToUploadWindow.Exists) {
            var Filename = ChooseFileToUploadWindow.Window("ComboBoxEx32", "", 1)
            Filename.Click();
            var path = ProjectSuite.Path + "\WorkstationData\\DDT\\Upload\\" + img;
            //Filename.Keys("^a");
            Filename.SetText(path);
            var open = ChooseFileToUploadWindow.Window("Button", "&Open", 1);
            open.Click();
            Delay(wait_time);
            PropArray = new Array("ClrClassName", "wText");
            ValuesArray = new Array("TextBox", path);
            var txtFilePath = Page.Find(PropArray, ValuesArray, _depth);
            if (txtFilePath.Exists) {
                Log.Message(txtFilePath + "," + "is selected in the textbox");
                return true;
            } else {
                Log.Message(txtFilePath + "," + "is not selected in the textbox");
                return false;
            }
        } else {
            Log.Message(ChooseFileToUploadWindow + "Not Opened");
            return false;
        }
    } catch (e) {
        Log.Message("select_Image() Error" + e.description);
    }
}
/*******************************************************************
[Purpose]
Enter the value to the field which is adjacent.
Ex:enterTextNearLabel("Name","FNJohn","TextBox")
********************************************************************/
function enterTextNearLabel(LabelText, ValueToEnter, elementType) {
    try {
        var Page = CommonVars.page;

        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", LabelText);
                var Labelobj = Page.Find(PropArray, ValuesArray, _depth);
                var Labelpar = Labelobj.Parent;
                //var Labeltxt = Labelpar.Findchild ();
                // var NameObj = "WPFObject(\"TextBox\")";
                if (Labelpar) {
                    PropArray = new Array("ClrClassName");
                    ValuesArray = new Array(elementType);
                    var txtBoxobj = Labelpar.FindChild(PropArray, ValuesArray, _depth);
                    if (txtBoxobj.Exists) {
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
                ValuesArray = new Array("TextBlock", NameText);
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                objcomboxelement = comboboxelement.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objcomboxelementclick = objcomboxelement.Find(PropArray, ValuesArray, _depth);
                if (objcomboxelementclick) {
                    objcomboxelementclick.Click();
                    PropArray = new Array("WPFControlText");
                    ValuesArray = new Array(ValueToEnter);
                    objValue = Page.Find(PropArray, ValuesArray, _depth);
                    objValue.Click();
                    if (objcomboxelementclick.wText == ValueToEnter) {
                        Log.Message(ValueToEnter + "is Selected");
                        return true;
                    } else if (objcomboxelementclick.SelectedValue.Name == ValueToEnter) {
                        Log.Message(ValueToEnter + "is Selected");
                        return true;
                    } else {
                        Log.Message(ValueToEnter + "is not Selected");
                    }
                } else {
                    Log.Message(objcomboxelementclick + "Not found");
                    return false;
                }
                break;
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, ValueToEnter);
                var objLabel = Page.Find(PropArray, ValuesArray, _depth);
                if (objLabel.Exists) {
                    objLabel.Click();
                    Log.Message(ValueToEnter + "is checked");
                    return true;
                } else {
                    Log.Message(ValueToEnter + "is not checked");
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
/**********************************************************************************************
[Purpose]
Verifies the Admin menu page is opened or not
Ex: verifyAdminMenuByName("User Management")
************************************************************************************************/
function verifyAdminMenuByName(MenuName) {
    try {
        var Page = CommonVars.page;
        var objBtn = Page.Find(["ClrClassName", "WPFControlText"], ["TabItem", MenuName], _depth);
        if (objBtn.Exists) {
            objBtn.HoverMouse();
            Log.Message(MenuName + ": Was avaliable");
            return true;
        } else {
            Log.Message(MenuName + ": Was not avaliable");
            return false;
        }
    } catch (e) {
        Log.Warning("verifyAdminMenuByName() catch error", +e.description);
        return false;
    }
}
/**********************************************************************************************
[Purpose]
Verifies the tab
Ex: verifyTab("Completed Jobs")
************************************************************************************************/
function verifyTab(ContentText) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("TabControl", "WPFObject(*\"TabControl*\")");
        var objtxtTab = Page.Find(PropArray, ValuesArray, _depth);
        //var objAllTabs =objtxtTab.FindAllChildren(["ClrClassName","Visible"],["TabItem","True"], _depth);
        for (var i = 0; i < objtxtTab.wTabCount; i++) {
            if (aqString.Contains(objtxtTab.Items.Item(i).WPFControlText, ContentText) != 0) {
                Log.Message(objtxtTab + "tab is avaliable");
                return true;
            }
        }
        return false;

    } catch (e) {
        Log.Message("verifyTab() Error" + e.description);
        return false;
    }
}
/**********************************************************************************************
[Purpose]
Verifies the tab
Ex: clickOnTab("Completed Jobs")
************************************************************************************************/
function clickOnTab(TabName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("WPFControlText", "ClrClassName");
        ValuesArray = new Array(TabName, "TabItem");
        var objtxtTab = Page.Find(PropArray, ValuesArray, _depth);
        if (objtxtTab.Exists) {
            objtxtTab.HoverMouse();
            objtxtTab.Click();
            Log.Message(objtxtTab + "tab is opened");
            return true;
        } else {
            Log.Message(objtxtTab + "tab is not opened");
            return false;
        }
    } catch (e) {
        Log.Message("clickOnTab() Error" + e.description);
        return false;
    }
}
/*************************************************************
[Purpose]
Clicks the Open Btn for the particular case.
Ex: clickOpenBtnForCase("WPFObject(\)")
***************************************************************/
function clickOpenBtnForCase(tableIDstr, compareColumnName, compareValue, columnToVerify, valueToVerify) {

    var columnIndextoCompare, columnIndextoverify, RowMatchedData;
    //var tableMapID = idStrMap('Table', tableIDstr);
    try {
        Page = CommonVars.page;
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = totalChildCount - (tblColCount - 1);

        if (RowCount >= 1) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj.Exists) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", columnToVerify]);
            if (columnHeaderObj.Exists) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }

        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj.Exists) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }
        var dataVerifyObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        var dataCellObj = dataVerifyObj.FindChild(["ClrClassName", "WPFControlText"], ["Label", valueToVerify], 200);
        var dataopenButtonObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "VisibleOnScreen"], ["Button", "Open", "True"], 200);
        if (dataopenButtonObj.Exists) {
            dataopenButtonObj.HoverMouse();
            dataopenButtonObj.click();
            Delay(wait_time);
            var objCaseSetup = AmazonCommonFuncs.verifyBtnByName("Return");
            if(objCaseSetup)
            return true;
            else
            return false;
        } else {
            return false;
        }
    } catch (e) {
        Log.Warning("clickOpenBtnForCase() catch error, " + e.description);
        return false
    }
}
/************************************************
[Purpose]
Search with the Patient Name/Patient ID and Status
Ex: search_Patient_verify("Patient","John","Open")
******************************************************/
function search_Patient_verify(ColumName, ColumValue, status) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("TextBox", "WPFObject(\"SearchBoxView\")");
        var txtSearchBoxobj = Page.Find(PropArray, ValuesArray, _depth);
        if (txtSearchBoxobj.Exists) {
            txtSearchBoxobj.Click();
            txtSearchBoxobj.Keys("^a[BS]");
            txtSearchBoxobj.Keys(ColumValue);
            txtSearchBoxobj.Keys("[Enter]");
            Delay(wait_time);
            var objPatientVerify = AmazonCommonFuncs.caseTableDataVerify("WPFObject(\"CaselistDataGrid\")", ColumName, ColumValue, "Status", status);
            //PropArray = new Array("ClrClassName", "Name");
            // ValuesArray = new Array("DataGridRow", "WPFObject(*\"DataGridRow*\")");
            //var txtCaseListObj = Page.Find(PropArray, ValuesArray, _depth);
            //PropArray = new Array("ClrClassName", "WPFControlText");
            //ValuesArray = new Array("TextBlock", caseID);
            //var txtCaseObj = txtCaseListObj.Find(PropArray, ValuesArray, _depth);
            //if (txtCaseListObj.Item.CaseAccessionNumber.OleValue==caseID && txtCaseListObj.Item.Status.OleValue==status) {
            if (objPatientVerify) {
                Log.Message(ColumValue + "," + "is Exists in the Case List");
                return true;
            } else {
                Log.Message(ColumValue + "," + "is Exists in the Case List");
                return false;
            }
        } else {
            Log.Message(txtSearchBoxobj + "not exits");
            return false;
        }
    } catch (e) {
        Log.Message("search_Patient_verify() Error" + e.description);
    }

}
/**************************************
[Purpose]
Verifies the Case table data 
Ex: search_Patient_verify("Patient","John","Open")
*****************************************/
function caseTableDataVerify(tableIDstr, compareColumnName, compareValue, columnToVerify, valueToVerify) {

    var columnIndextoCompare, columnIndextoverify, RowMatchedData;
    //var tableMapID = idStrMap('Table', tableIDstr);
    try {
        Page = CommonVars.page;
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = totalChildCount - (tblColCount - 1);

        if (RowCount >= 1) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj.Exists) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", columnToVerify]);
            if (columnHeaderObj.Exists) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }

        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj.Exists) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }
        var dataVerifyObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        var dataCellObj = dataVerifyObj.FindChild(["ClrClassName", "WPFControlText"], ["Label", valueToVerify], 200);
        if (dataCellObj.Exists)
            return true;
        else
            return false;
    } catch (e) {
        Log.Message("caseTableDataVerify() catch error, " + e.description);
        return false
    }
}

//================================================= 
function ClickDissectButtononStage(action) {
    try {
        PropArray = new Array("ClrClassName", "VisibleOnScreen");
        ValuesArray = new Array("Canvas", "True");
        var notificationwindow = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {
            PropArray = new Array("Name", "WPFControlText", "VisibleOnScreen");
            ValuesArray = new Array("WPFObject(\"btnDissect\")", action, "True");
            var notificationwindowOkBtn = CommonVars.page.Find(PropArray, ValuesArray, _depth);
            if (notificationwindowOkBtn.Exists) {
                notificationwindowOkBtn.HoverMouse();
                notificationwindowOkBtn.Click();
                return true;
            }
        }

    } catch (e) {
        Log.Message("ClickDissectButtononStage() Error" + e.description);
    }
}
//===============================================================================
function VerifyNotificationWindowMsg(ContentText, ifContains) {
    var ifContains = false || ifContains
    try {
        Page = CommonVars.page;
        PropArray = new Array("ClrClassName");
        ValuesArray = new Array("HwndSource");
        var notificationwindow = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        //ClrClassName Content
        if (notificationwindow.Exists) {
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("ContentControl", ContentText);
            var notificationwindowOkBtn = Page.Find(PropArray, ValuesArray, _depth);
            if (aqString.Find(notificationwindowOkBtn.WPFControlText, ContentText) != -1) {
                Log.Message("Substring '" + ContentText + "' was found in string '");
                return true;
            } else {
                Log.Message("Substring '" + ContentText + "' was NOT found in string '");
                return false;
            }
        } else {
            Log.Message(notificationwindow + "object not exists");
            return false;
        }

    } catch (e) {
        Log.Message("VerifyNotificationWindowMsg() Error" + e.description);
    }
}
//==================================================================================
function clickEditBtnForUser(tableIDstr, compareColumnName, compareValue, columnToVerify, valueToVerify) {

    var columnIndextoCompare, columnIndextoverify, RowMatchedData;
    //var tableMapID = idStrMap('Table', tableIDstr);
    try {
        Page = CommonVars.page;
        PropArray = new Array("Name", "ClrClassName");
        ValuesArray = new Array(tableIDstr, "DataGrid");
        var tblObj = Page.Find(PropArray, ValuesArray, _depth);
        var totalChildCount = tblObj.ChildCount;
        var tblColCount = tblObj.wColumnCount;
        var RowCount = totalChildCount - (tblColCount - 1);

        if (RowCount > 1) {
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", compareColumnName]);
            if (columnHeaderObj.Exists) {
                columnIndextoCompare = columnHeaderObj.WPFControlIndex;
            }
            var columnHeaderObj = tblObj.FindChild(["ClrClassName", "Content"], ["DataGridColumnHeader", columnToVerify]);
            if (columnHeaderObj.Exists) {
                columnIndextoverify = columnHeaderObj.WPFControlIndex;
            }
        }

        var dataGridCelllsObj = tblObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", compareValue, columnIndextoCompare], 200);
        if (dataGridCelllsObj.Exists) {
            RowMatchedData = dataGridCelllsObj.Parent.WPFControlIndex
            Log.Message("Found data at column" + columnIndextoCompare + " and row " + dataGridCelllsObj.Parent.WPFControlIndex)
        }
        var dataVerifyObj = tblObj.FindChild(["ClrClassName", "WPFControlOrdinalNo"], ["DataGridRow", RowMatchedData], 200);
        var dataCellObj = dataVerifyObj.FindChild(["ClrClassName", "WPFControlText", "WPFControlOrdinalNo"], ["DataGridCell", valueToVerify, columnIndextoverify], 200);
        var objParent = dataCellObj.Parent;
        var dataEditBtnObj = objParent.Find(["ClrClassName", "WPFControlText"], ["Button", "Edit"], 200);
        if (dataEditBtnObj) {
            dataEditBtnObj.HoverMouse();
            dataEditBtnObj.click();
            return true;
        } else {
            return false;
        }
    } catch (e) {
        Log.Warning("clickEditBtnForUser() catch error, " + e.description);
        return false
    }
}
//================================================
function VerifyAnyText(NameText, elementType) {
    try {
        var Page = CommonVars.page;
        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
            case "DATEPICKER":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    txtBoxobj.HoverMouse();
                    return true;
                }
                break;
            case "PASSWORDBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    return true;
                }
            case "CHECKBOX":
            case "RADIOBUTTON":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array(elementType, NameText);
                var objLabel = Page.Find(PropArray, ValuesArray, _depth);
                if (objLabel.IsChecked.OleValue == true) {
                    return true;
                } else if (objLabel.IsChecked.OleValue == false) {
                    return true;
                }
                Log.Message(objLabel + "does not exists");
                return false;

                break;
            case "COMBOBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var comboboxelement = Page.Find(PropArray, ValuesArray, _depth);
                objcomboxelement = comboboxelement.Parent;
                PropArray = new Array("ClrClassName", "Visible");
                ValuesArray = new Array(elementType, "True");
                objcomboxelementclick = objcomboxelement.Find(PropArray, ValuesArray, _depth);
                if (objcomboxelementclick.Exists) {
                    return true;
                } else {
                    Log.Message(objcomboxelementclick + "Not found");
                    return false;
                }
                break;

            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("VerifyAnyText() Error" + e.description);
    }
}
//======================================================================
function VerifyFieldIsDisabled(NameText, elementType) {
    try {
        var Page = CommonVars.page;
        switch (aqString.ToUpper(elementType)) {
            case "TEXTBOX":
            case "TEXTAREA":
            case "DATEPICKER":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "IsEnabled");
                ValuesArray = new Array(elementType, "False");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    txtBoxobj.HoverMouse();
                    Log.Message(txtBoxobj + "is disabled");
                    return true;
                }
                break;
            case "PASSWORDBOX":
                PropArray = new Array("ClrClassName", "WPFControlText");
                ValuesArray = new Array("TextBlock", NameText);
                var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
                var objparent = txtBlockobj.Parent;
                PropArray = new Array("ClrClassName", "IsEnabled");
                ValuesArray = new Array(elementType, "False");
                txtBoxobj = objparent.Find(PropArray, ValuesArray, _depth);
                if (txtBoxobj.Exists) {
                    return true;
                }
                break;

            default:
                Log.Message(element + " coverage is not implemented in the code!");
        } //end of Switch

    } catch (e) {
        Log.Message("VerifyFieldIsDisabled() Error" + e.description);
    }
}

/*******************************************************************************
[Purpose]
verifies the sample overview screen is opened or not
Ex: verifySampleOverviewScreen()
Created By: Janardhana
*******************************************************************************/
function verifySampleOverviewScreen() {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name", "VisibleOnScreen");
        ValuesArray = new Array("DynamicScrollViewer", "WPFObject(\"ScrollViewer\")", "True");
        var objSampleScreen = Page.Find(PropArray, ValuesArray, _depth);
        if (objSampleScreen.Exists) {
            Log.Message("Sample overview screen is opened");
            return true;
        } else {
            Log.Message("Sample overview screen is not opened");
            return false;
        }
    } catch (e) {
        Log.Message("verifySampleOverviewScreen() Error" + e.description);
        return false;
    }
}
/*******************************************************************************
[Purpose]
verifies the Stage overview screen is opened or not
Ex: verifyScreen()
Created By: Janardhana
*******************************************************************************/
function verifyScreen() {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("StageOverviewView", "WPFObject(*\"StageOverviewView*\")");
        var objStageOverviewScreen = Page.Find(PropArray, ValuesArray, _depth);
        if (objStageOverviewScreen.Exists) {
            Log.Message(objStageOverviewScreen + "Page is exists");
            return true;
        } else {
            Log.Message(objStageOverviewScreen + "Page is exists");
            return false;
        }
    } catch (e) {
        Log.Message("verifyScreen() Error" + e.description);
        return false;
    }
}
/*******************************************************************************
[Purpose]
verifies the Tool is present or not
Ex: verifyToolbarTool("Pan"),verifyToolbarTool("Undo")
Created By: Janardhana
*******************************************************************************/
function verifyToolbarTool(ToolbarName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ToolTip", "VisibleOnScreen");
        ValuesArray = new Array(ToolbarName, true);
        var objTool = Page.Find(PropArray, ValuesArray, _depth);
        if (objTool.ToolTip.OleValue == ToolbarName) {
            Log.Message(ToolbarName + " Tool is avaliable on Sample overview Screen");
            return true;
        } else {
            Log.Message(ToolbarName + " Tool is not avaliable on Sample overview Screen");
            return false;
        }
    } catch (e) {
        Log.Message("verifyToolbarTool() Error" + e.description);
    }
}
/*******************************************************************************
[Purpose]
verifies the Tool is Enabled or not
Ex: verifyToolEnabled("Pan"),verifyToolEnabled("Undo")
Created By: Janardhana
*******************************************************************************/
function verifyToolEnabled(ToolbarName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ToolTip", "VisibleOnScreen");
        ValuesArray = new Array(ToolbarName, true);
        var objTool = Page.Find(PropArray, ValuesArray, _depth);
        if (objTool.IsEnabled == true) {
            Log.Message(ToolbarName + " is Enabled");
            return true;
        } else {
            Log.Message(ToolbarName + " is not Enabled");
            return false;
        }
    } catch (e) {
        Log.Message("verifyToolEnabled() Error" + e.description);
    }
}
/*******************************************************************************
[Purpose]
Click on the Tool 
Ex: clickOnTool("Pan"),clickOnTool("Undo")
Created By: Janardhana
*******************************************************************************/
function clickOnTool(ToolbarName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ToolTip", "VisibleOnScreen");
        ValuesArray = new Array(ToolbarName, true);
        var objTool = Page.Find(PropArray, ValuesArray, _depth);
        if (objTool.IsEnabled == true) {
            objTool.Click();
            Log.Message(ToolbarName + " is Enabled");
            return true;
        } else {
            Log.Message(ToolbarName + " is not Enabled");
            return false;
        }
    } catch (e) {
        Log.Message("clickOnTool() Error" + e.description);
    }
}
/*******************************************************************************
[Purpose]
Click on Addgroupbutton to add new group
Ex: clickOnAddGroupBtn()
Created By: Janardhana
*******************************************************************************/
function clickOnAddGroupBtn() {
    try {
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("GroupOfAnnotationView", "WPFObject(\"Gp\")");
        var objGroupPanel = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        if (objGroupPanel.Exists) {
            var objAddGroupBtn = objGroupPanel.FindChild(["ClrClassName", "Name", "VisibleOnScreen"], ["Button", "WPFObject(*\"Button*\")", true], _depth);
            if (objAddGroupBtn.Exists) {
                objAddGroupBtn.Click();
                return true;
            } else
                return false;
        } else {
            Log.Message(objGroupPanel + " doesn't Exists");
            return false;
        }
    } catch (e) {
        Log.Message("clickOnAddGroupBtn() Error" + e.description)
    }
}
/*******************************************************************************
[Purpose]
Verifies group is created or not
Ex: verifyGroup()
Created By: Janardhana
*******************************************************************************/
function verifyGroup() {
    try {
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("TreeView", "WPFObject(\"treeView\")");
        var objGroupIcons = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        var objGrpCount = objGroupIcons.wItems.Count;
        if (objGrpCount == 2) {
            Log.Message("Group 2 is created successfully");
            return true;
        } else if (objGrpCount == 3) {
            Log.Message("Group 3 is created successfully");
            return true;
        } else if (objGrpCount == 4) {
            Log.Message("Group 4 is created successfully");
            return true;
        } else {
            return false;
        }
    } catch (e) {
        Log.Message("verifyGroup() Error" + e.description);
    }
}
/*******************************************************************************
[Purpose]
verifies the page 
Ex: VerifyPage()
*******************************************************************************/
function VerifyPage(ObjClass, ObjName) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array(ObjClass, ObjName);
        var VerifyObj = CommonVars.page.Find(PropArray, ValuesArray, _depth);
        if(VerifyObj.Exists){
        Log.Message("User is in" + ObjName);
        return true;
        }else{
        return false;
        }
    } catch (e) {
        Log.Warning("VerifyPage() catch error, " + e.description);
        return false
    }
}