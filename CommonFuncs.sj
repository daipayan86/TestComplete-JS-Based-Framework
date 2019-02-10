////USEUNIT CommonVars
////USEUNIT Properties
////USEUNIT ReportCommonFuncs
  



/***********************************************************************
[Purpose]
Load page with given URL and validated page is loaded.

[Parameters] 
Home page identifier and header title in loaded page.

Created: Samitha Karunaratne  Date:05/12/2014 
Updated: Samitha Karunaratne  Date:08/05/2014  Reason: 1. Reading data from DDT/Config
                                                       2. Having common implemntation for loading all workstation, Instead of having separate code blocks
*************************************************************************/ 
function Load(home,headerTitle)
{ 
  CommonVars._pageload_status = false;
 //Reading data from DDT/Config
  var dataset = CommonFuncs.CSVDataDriver(home);
  if(!(dataset.length > 0)){
    Log.Warning("Load(), incorrect home variable: " + home);
  }  
  Properties.APP_HOME = dataset[1];
  Properties.SERVER_IP = dataset[3];
  Properties.BROWSER = dataset[4];

  //Terminate IE instances if any     
   Close_browser();
   delay(wait_time_long);

  //Loading workstation home page  
  try{
    CommonVars.home_page = Properties.APP_HOME;   
    Browsers.Item(Properties.BROWSER).Run(CommonVars.home_page);  
    var browser = Sys.FindChild("ProcessName", Properties.BROWSER); 
    delay(wait_time);
    browser.BrowserWindow(0).Maximize(); //maximize browser
    Properties.BrowserInfo = browser.ProcessName +" "+ browser.FileVersionInfo.MajorPart;
    Log.Message("Loaded browser version - " + Properties.BrowserInfo);
    var page = browser.FindChild("URL", "http://"+ Properties.SERVER_IP + "/web/*");
    objHeaderTitle = CommonFuncs.Find_visible_object_with_timeout("idStr","ws-login-title", _depth); 
  }catch(e){
    Log.Error(e);
    Log.Error(Properties.BrowserInfo + " may not setup, loaded or not compatible with current TC version!");
    //Runner.Stop();
  }
  
      
    verifyPageHeaderTitle(objHeaderTitle);
 
  var count = 1;
  function verifyPageHeaderTitle(objHeaderTitle)
  {     
    try {    
        Delay(wait_time);
        if(objHeaderTitle.contentText == headerTitle) //title page has loaded
        {
          Log.Message(headerTitle + " Page has been loaded");
          CommonVars._pageload_status = true;
        }
    } catch (e) {
      Log.Message(headerTitle + " Page is not fully loaded...");
       if (count < 4){
         verifyPageHeaderTitle(objHeaderTitle);
         count++;
       }
    }
  }
}   
  
/***********************************************************************
[Purpose]
Click on given button object

[Parameters] 
obj: button object to click.

Created: Samitha Karunaratne  Date:05/12/2014
*************************************************************************/
function clickButton(objBtn)
{    
try { 
 if(objBtn.Exists)
 {  
    objBtn.HoverMouse();
    Delay(500);
    objBtn.Click();
    //Log.Message("Clicked " + objBtn.idStr);          
 }
 else
 {
    Log.Warning("Could not found the object for click");
 }
 
 } catch (e) {
   Log.Warning("clickButton(), Button does not exists")
   return false;
 } 
 
 }

/***********************************************************************
Author: Ke Wang
Modified: 12/17/2012

[Purpose]
To return a unique string based on current data/time.
This is for generating an unique id to avoid duplicates.

[Parameters] 
no parameter.

[Return]
return the UID, for example: 1217171104 stands for (Dec.17 - 17:11:04)  
*************************************************************************/
function Get_unique_id()
{
  var UID;
  var CurrentDate = aqDateTime.Today();
  var CurrentTime = aqDateTime.Time();

  // Return the parts of the current date&time
  var Year = aqDateTime.GetYear(CurrentDate);
  var Month = aqDateTime.GetMonth(CurrentDate);
  var Day = aqDateTime.GetDay(CurrentDate);
  var Hours = aqDateTime.GetHours(CurrentTime);
  var Minutes = aqDateTime.GetMinutes(CurrentTime);
  var Seconds = aqDateTime.GetSeconds(CurrentTime);


  if(Month<10)
    Month = "0" + Month;
  if(Day<10)
    Day = "0" + Day;
  if(Hours<10)
    Hours = "0" + Hours;
  if(Minutes<10)
    Minutes = "0" + Minutes;
  if(Seconds<10)
    Seconds = "0" + Seconds;

          
  UID = Month+""+Day+""+Hours+""+Minutes+""+Seconds;
  return UID;
}

function Enter_text(obj,text)
{
    if(obj.Exists)
    {
          obj.Click(); 
          //obj.Keys("^a");
          //obj.Keys("[BS]");
          obj.Value("");
          obj.Keys(text);
          Delay(1000);
    }
}
/***********************************************************************
Author: Ke Wang
Modified: 12/18/2012

[Purpose]
Customize Find method with Timeout feature.
Try to find object until timeout.
 
Reference:  Properties.TIME_OUT_FOR_FINDING_OBJECT

[Parameters] 
PropArray, ValuesArray, _depth
Same as tc find method.

[Return]
return the object match searched criteria
*************************************************************************/
function Find_object_with_timeout(PropArray, ValuesArray, _depth)
{
      var obj;
      var time_start, time_end, time_used;
      time_start = aqDateTime.Time();

      Sys.Refresh();
      
      var page = Sys.Browser("*").Page("*");
      count=0;
      while(true)
      {   
          count = count+1;
          obj = page.Find(PropArray, ValuesArray, _depth);
          if(obj.Exists)
          {  
                //obj.HoverMouse(); 
                Log.Message("obj:"+obj.FullName);  
                break; 
          }
          else
              Delay(wait_time_long);
              
          time_end = aqDateTime.Time();
          time_used = aqDateTime.TimeInterval(time_start, time_end);
          time_used = aqConvert.TimeIntervalToStr(time_used);  //0:00:01:08
          time_used_mins = time_used.charAt(time_used.length-5)+time_used.charAt(time_used.length-4)  //01
          time_used_mins = aqConvert.VarToInt(time_used_mins);
          time_used_secs = time_used.charAt(time_used.length-2)+time_used.charAt(time_used.length-1)  //08
          time_used_secs = aqConvert.VarToInt(time_used_secs);
          time_used = time_used_mins*60 + time_used_secs;
          
          
          if(time_used > aqConvert.VarToInt(Properties.TIME_OUT_FOR_FINDING_OBJECT / 1000 * 6))
          {                    
              Log.Message("Find_object_with_timeout() error " + time_used + " seconds already, "+ ValuesArray + " object still could not found, timeout!");
              return null;
          }
     }
     return obj; 
}

/************************************************************************

 [Purpose]: Find an object with a timeout. The timeout is divided into 3 sequences: 1/6, 2/6, 3/6 
 of the original time. eg. 5,10,15 seconds, 
 
 [Parameters]: PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
  
 [Author]: Paolo Co
 
 *************************************************************************/
 
function Find_visible_object_with_timeout(PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 60000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "VisibleOnScreen"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("VisibleOnScreen");
    ValuesArray.push("True");
  } else {
    Log.Message("Find_visible_object_with_timeout() error");
    return false
  }

  //find the object with given time out
  Sys.Refresh();
  var page = Sys.Browser("*").Page("*");
  count=0;
  while(count < 3){   
    count = count+1;
    var obj = page.Find(PropArray, ValuesArray, _depth);
    if(obj.Exists){  
          return obj
    } else {
        if(Properties.STATION == 'WPW') {
            break;
        } 
      Delay(timeout * (count / 6)); // given 60 sec: 10/60, 20/60, 30/60
    }
  }
  Log.Error("Find_visible_object_with_timeout() error. Item not found, ValueArray: " + ValuesArray)
  return null; 
}

 /************************************************************************

 [Purpose]: Same with FindAll_visible_object_with_timeout() but findsAll
 
 [Parameters]: PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
 
 [returns]:  array of objects or null
  
 [Author]: Paolo Co
 
 *************************************************************************/
 
function FindAll_visible_object_with_timeout(PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 30000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "VisibleOnScreen"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("VisibleOnScreen");
    ValuesArray.push("True");
  } else {
    Log.Message("FindAll_visible_object_with_timeout() error");
    return null
  }

  //find the object with given time out
  Sys.Refresh();
  var page = CommonVars.page;
  count=0;
  while(count < 3){   
    count = count+1;
    var obj = page.FindAll(PropArray, ValuesArray, _depth);
        obj = (new VBArray(obj)).toArray();
    if(obj.length > 0){  
          return obj
    } else {
      Delay(timeout * (count / 6)); // given 60 sec: 10/60, 20/60, 30/60
    }
  }
  return null; 
}

 /************************************************************************

 [Purpose]: find elements from a parent
 
 [Parameters]: Parent, PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
 
 [returns]:  array of objects or null
  
 [Author]: Paolo Co
 
 *************************************************************************/
 
function find_all_children_with_timeout(Parent, PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 30000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "VisibleOnScreen"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("VisibleOnScreen");
    ValuesArray.push("True");
  } else {
    Log.Message("FindAll_visible_object_with_timeout() error");
    return null
  }

  //find the object with given time out
  count=0;
  while(count < 3){   
    count = count+1;
    var obj = Parent.FindAllChildren(PropArray, ValuesArray, _depth);
        obj = (new VBArray(obj)).toArray();
    if(obj.length > 0){  
          return obj
    } else {
      Delay(timeout * (count / 6)); // given 60 sec: 10/60, 20/60, 30/60
    }
  }
  return null; 
}

 /************************************************************************

 [Purpose]: find all elements from a parent
 
 [Parameters]: Parent, PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
 
 [returns]:  array of objects or null
  
 [Author]: David Luu
 
 *************************************************************************/
 
function find_all_available_children(Parent, PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 30000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "Visible"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("Visible");
    ValuesArray.push("True");
  } else {
    Log.Message("find_all_available_children() error");
    return null
  }

  //find the object with given time out
    var obj = Parent.FindAllChildren(PropArray, ValuesArray, _depth);
    /*if(!obj) {
        Log.Warning("find_all_available_children() error, cannot find object.");
        return null
    }*/
    obj = (new VBArray(obj)).toArray();
    if(obj.length > 0){
          return obj
    }
    Log.Warning("find_all_available_children() error, nothing in object.");  
    return null; 
}



 /************************************************************************

 [Purpose]: find elements from a parent
 
 [Parameters]: Parent, PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
 
 [returns]:  array of objects or null
  
 [Author]: Paolo Co
 
 *************************************************************************/
 
function find_child_with_timeout(Parent, PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 30000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "VisibleOnScreen"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("VisibleOnScreen");
    ValuesArray.push("True");
  } else {
    Log.Message("FindAll_visible_object_with_timeout() error");
    return null
  }

  //find the object with given time out
  count=0;
  while(count < 3){   
    count = count+1;
    var obj = Parent.FindChild(PropArray, ValuesArray, _depth);
    if(obj.Exists){  
          return obj
    } else {
      Delay(timeout * (count / 6)); // given 60 sec: 10/60, 20/60, 30/60
    }
  }
  return null; 
}

/***********************************************************************
Author: Ke Wang
Modified: 12/28/2012

[Purpose]
Customize FindAll method with Timeout feature.
Try to find object until timeout.
 
Reference:  Properties.TIME_OUT_FOR_FINDING_OBJECT

[Parameters] 
PropArray, ValuesArray, _depth
Same as tc find method.

[Return]
return the object array match searched criteria
*************************************************************************/
function FindAll_object_with_timeout(PropArray, ValuesArray, _depth)
{
      var obj,i;
      var time_start, time_end, time_used;
      time_start = aqDateTime.Time();

      Sys.Refresh();
      var page = CommonVars.page;
      while(true)
      {   
          obj = page.FindAll(PropArray, ValuesArray, _depth);
          obj = (new VBArray(obj)).toArray();

          if(obj.length>0)
          {  
/*              for (i = 0; i < obj.length; i++)
              {
                  obj[i].HoverMouse();
                  Log.Message("FullName: " + obj[i].FullName + "\r\n");   
              }
*/
              return obj; 
          }
          else
              Delay(wait_time_long);
              
          time_end = aqDateTime.Time();
          time_used = aqDateTime.TimeInterval(time_start, time_end);
          time_used = aqConvert.TimeIntervalToStr(time_used);  //0:00:01:08
          time_used_mins = time_used.charAt(time_used.length-5)+time_used.charAt(time_used.length-4)  //01
          time_used_mins = aqConvert.VarToInt(time_used_mins);
          time_used_secs = time_used.charAt(time_used.length-2)+time_used.charAt(time_used.length-1)  //08
          time_used_secs = aqConvert.VarToInt(time_used_secs);
          time_used = time_used_mins*60 + time_used_secs;
          
          
          if(time_used > aqConvert.VarToInt(Properties.TIME_OUT_FOR_FINDING_OBJECT / 1000 * 6))
          {                    
              Log.Warning(time_used + " seconds already, object still could not found, timeout!");
              //ReportCommonFuncs.Report_a_verify("")
              return null;
          }
     }
     return obj; 
}

 
/***********************************************************************
Author: Ke Wang
Modified: 12/18/2012

[Purpose]
Find object by id.

[Parameters] 
id: Id value in TestComplete tree-mode.

[Return]
return the object found.
*************************************************************************/
function Find_object_by_id(id)
{
    var page = Sys.Browser(Properties.BROWSER).Page("*");
    found = page.Find("Id",id,_depth); 
       
    if(Properties.DEBUG_DEVELOPER)
    {
        if(found.Exists)
                       
            Log.Message("Object Found by ID:"+id, found.FullName);
             
        else 
            Log.Warning("Object not found."); 
     }
     return found;
}

/***********************************************************************
Author: Ke Wang
Modified: 12/27/2012

[Purpose]
Find the first specific ObjectType from start id.

[Parameters] 
start_id: Id value in TestComplete tree-mode,searching from this id(not include).
type: ObjectType in TestComplete tree-mode. 

[Return]
return the object found.
*************************************************************************/
function Find_next_objecttype(start_id, type)
{
    var id, i, obj;
    id = start_id;
    for (i=id+1; i < id+100; i++)
    {
            obj = Find_object_by_id(i);
            if(obj.Exists)  
            {
                if (obj.ObjectType == type)
                {
                    Log.Message(type + " found,id:"+obj.Id, obj.FullName);
                    return obj;
                }
            }
    }
    return obj;
}

/***********************************************************************
Author: Ke Wang
Modified: 12/27/2012

[Purpose]
HoverMouse give object

[Parameters] 
Any visible page objects 

[Return]
no return
*************************************************************************/
function Hover_mouse(obj)
{
    try
    {
       obj.HoverMouse();
    }
    catch (e)
    {    Log.Warning(e.description);}
}

/***********************************************************************
Author: Ke Wang
Modified: 12/27/2012

[Purpose]
Find the first Textbox by specific text string.

[Parameters] 
str: string value in Webpage.

[Sample]
Get_textbox_nextby_text("Lab Site:")

[Return]
return the object found.
*************************************************************************/
function Get_textbox_nextby_text(str)
{
    obj = CommonFuncs.Get_element_textnode(str);
    obj = CommonFuncs.Find_next_objecttype(obj.Id,"Textbox");
    return obj;
}

function Get_textarea_nextby_text(str)
{
    obj = CommonFuncs.Get_element_textnode(str);
    obj = CommonFuncs.Find_next_objecttype(obj.Id,"Textarea");
    return obj;
}
/***********************************************************************
Author: Ke Wang
Modified: 12/26/2012

[Purpose]
General function to obtain a Textbox element (HTML input).

[Parameters] 
idstr: idstr in TC object browser.

[Sample]
Get_element_textbox("priority-input")

[Return]
return the input object matchs searching criteria
*************************************************************************/
function Get_element_textbox(idstr)
{
    PropArray = new Array("ObjectType", "idStr");
    ValuesArray = new Array("Textbox", idstr);

    obj = CommonFuncs.Find_object_with_timeout(PropArray, ValuesArray, _depth);

    if(obj.Exists)
    {   Log.Message("Textbox Input element: "+idstr+" Found.");
        obj.HoverMouse();
    }    
    else
    {   Log.Warning("Textbox Input element: "+idstr+" not exists.");  
    } 

    return obj; 
}

/***********************************************************************
Author: Ke Wang
Modified: 12/26/2012

[Purpose]
General function to obtain a TextNode element.

[Parameters] 
str: innerText in TC object browser.

[Sample]
Get_element_textnode("*Client Name*")

[Return]
return the object matchs searching criteria
*************************************************************************/
function Get_element_textnode(str)
{
    PropArray = new Array("ObjectType", "innerText");
    ValuesArray = new Array("TextNode", str);

    obj = CommonFuncs.Find_object_with_timeout(PropArray, ValuesArray, _depth);

    if(obj.Exists)
    {   Log.Message("TextNode element: '"+str+"' Found.");
        obj.HoverMouse();
    }    
    else
    {   Log.Warning("TextNode element: '"+str+"' not exists.");  
        obj=null;
    } 

    return obj; 
}


/***********************************************************************
Author: Ke Wang
Modified: 12/26/2012

[Purpose]
General function to verify if a element exists or not.

[Parameters] 
type: ObjectType, for example: TextNode, or Button
text: innerText of the element.

[Sample]
Verify_element("Button","Cancel")

[Return]
true: if element exists.
false: if element not exists.
*************************************************************************/
function Verify_element(type,text)
{
    PropArray = new Array("ObjectType", "innerText");
    ValuesArray = new Array(type, text);

    obj = CommonFuncs.Find_object_with_timeout(PropArray, ValuesArray, _depth);

    if(obj.Exists)
    {   Log.Message("Element: "+text+" Found.");
        obj.HoverMouse();
        ret = true;
    }    
    else
    {   Log.Warning("Element: "+text+" not exists.");  
        ret = false;
    }    
    return ret;
}




function Get_element(type,text)
{
    PropArray = new Array("ObjectType", "innerText");
    ValuesArray = new Array(type, text);

    obj = CommonFuncs.Find_object_with_timeout(PropArray, ValuesArray, _depth);

    if(obj.Exists)
    {   Log.Message("Element: "+text+" Found.");
        obj.HoverMouse();
    }    
    
    return obj;
}




/***********************************************************************
Author: Ke Wang
Modified: 12/18/2012

[Purpose]
Log test case as PASS if verify pass.
Log test case as FAIL if verify pass.
*************************************************************************/
function Verify_final_result(ret)
{
    if(!ret)
        Flag_fail(); 
    else
        Flag_pass();
}
function Flag_pass()
{
    CommonVars._passed_count++;
    if(Properties.TestReporting=="TEXT"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
    Log.Message(final_result);
    }
    
    if(Properties.TestReporting=="HTML"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
      Log.Message(final_result);
    }   
    
    if(Properties.TestReporting=="HPQC"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
      Log.Message(final_result);
    }  
    
}
function Flag_fail()
{
    CommonVars._failed_count++;
    if(Properties.TestReporting=="TEXT"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" FAIL! ---------------- ";
      ReportCommonFuncs.Report_a_verifySummary("");    
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("FAIL");
      ReportCommonFuncs.PrintResultToXML("Yes" , "FAIL");
      Log.Error(final_result);
    }
    
    if(Properties.TestReporting=="HTML"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" FAIL! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary("");    
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      ReportCommonFuncs.PrintResultToExcelDriver("FAIL");
      ReportCommonFuncs.PrintResultToXML("Yes" , "FAIL");
      Log.Error(final_result);
    }
}

function Run_cmd_line(cmd_line)
{
  p = Sys.Process("cmd");
  w = p.Window("ConsoleWindowClass", "*");
  w.Keys(cmd_line+" [Enter]");
  Log.Message("Run command line: " + cmd_line);
  Delay(10000);
  w.Keys("exit");
}   

/***********************************************************************
[Purpose]
Do some preparation before test, like generate report header...,etc.

Modified By: Samitha K Date Modified: 04/16/2014 Reason: Creating unique folder at the begining of each automation script execution. 
Modified By: Samitha K Date Modified: 11/24/2014 Reason: Retriving data from Vantage database. 
*************************************************************************/
function Begin_test()
{
    Properties.db = CommonFuncs.getValueFromCSV("Database", Properties.STATION); 
    Properties.TestReporting = CommonFuncs.getValueFromCSV("TestReporting", Properties.STATION);
    Properties.description = CommonFuncs.getValueFromCSV("Description", Properties.STATION);
    
    //Use Properties.db value to retrive data from Vantage DB
    
//    var listSystemInfo = DbConn.listDbDataSystemInfo();   
//    Properties.BUILD = listSystemInfo.split(",")[0]; //To use in report header
//    //Properties.LAN_VERSION = listSystemInfo.split(",")[1]; //To find out which languge file to be loaded
//    Properties.LAN_VERSION = "en-US";
    
    
   // Properties.UID  = aqString.SubString(Properties.TC, 3, 7)//Get the UID from Propertise.TC    
    Properties.UID  = Properties.TC.substring(3,parseInt((Properties.TC).indexOf('_')))    
    // Update Run status in Result XML
    ReportCommonFuncs.PrintResultToXML("Yes");
    if(Properties.TestReporting == "HPQC"){
      var Ret = qcConnect();
      Log.Message("qcConnect() return code: "+Ret);
    } else {
    
      ReportCommonFuncs.Report_header();
      _tc_count++;
 
     //Start modify, 04/16/2014   
     CommonVars.strScreenshotPath =  Project.Path+"\Screenshots\\"+Properties.TC;  
     CommonVars.ScreenshotID = 1;  //Intialize screenshot number sequence.
     ReportCommonFuncs.CreateReportFolder(CommonVars.strScreenshotPath); 
     CommonVars._final_result = true;
    }
   //End modify
   
   //Samitha- 11/24 Based on the Properties.LAN_VERSION, language files for localization should be loaded.
   
   
   //End  
    
}

/***********************************************************************
Author: Ke Wang
Modified: 12/21/2012

[Purpose]
Do some wrap up work after test, like logout, generate report footer...,etc.
*************************************************************************/
function Finish_test()
{
//    CommonFuncs.Logout();
  //reset _configNum
  CommonVars._configNum = '';
  CommonVars._configName = "";
  if(aqString.ToUpper(Properties.TestReporting) == "HPQC"){
    qcDisconnect();
  } else {
    ReportCommonFuncs.Report_footer(); 
    
    if  ( Properties.TC.indexOf("share.case") != -1  ||
          Properties.TC.indexOf("audit.report") != -1  
        )
        CommonFuncs.Close_browser(); 
  } 
}



/************************************************************************

 Author: Samitha Karunaratne
 DateCreated: 05/14/2014 
  
 [Purpose]:
 Creates a driver to read and return dataset for matching mudule, UID from MS excel data sheet.
 
 [Parameter]:
 Module: MS excel data sheet name
 UID: Script UID
 
 [Return]
 dataset array
 
 *************************************************************************/

function DataDriver(Module, UID)
{
  var Driver;
  Log.Message("Reading data from driver excel file..");
  
  // Creates the driver using ACEDriver
  var filename = "../WorkstationData/DDT/PreConditionData.xlsm";
  Driver = DDT.ExcelDriver(filename, Module, true); 
  
  // Iterates through records
  RecNo = 0;
  var dataSet = new Array();
  while (! Driver.EOF() ) 
  {
    arrDataSet = ProcessData(UID); // Processes data for given UID
    Driver.Next(); // Goes to the next record
  }
  
  // Closing the driver
  DDT.CloseDriver(Driver.Name);
  return arrDataSet;
  
  //Read data for given UID
  function ProcessData(UID)
  {
    var i;   
      for(i = 0; i < DDT.CurrentDriver.ColumnCount; i++)
      {
        if(DDT.CurrentDriver.Value(0)==UID) 
        {
        Log.Message(DDT.CurrentDriver.ColumnName(i) + ": " + aqConvert.VarToStr(DDT.CurrentDriver.Value(i)));
        dataSet[i] = aqConvert.VarToStr(DDT.CurrentDriver.Value(i)); 
        }
      }   
    RecNo = RecNo + 1; 
    return dataSet;
  } 
}

/************************************************************************

 Author: Samitha Karunaratne
 DateCreated: 06/17/2014 
  
 [Purpose]:
 Read excel data sheet and get data from given cell location.
 
 [Parameter]:
 Module: MS excel data sheet name
 rowIndex: start from index 1
 colIndex: start from index 1
 
 [Return]
 cell calue
 
 *************************************************************************/
function getDataFromExcel(module, rowIndex, colIndex)
{  
  var Driver;
  Log.Message("Reading data from driver excel file..");
  
  // Creates the file name
  var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\PreConditionData.xlsm";

  //Closing if any excel file open.
  var p = Sys.FindChild("ProcessName", "EXCEL");
  while(p.Exists){ 
    p.Close();
 
    //Wait until the process is closed. 
    isClosed = p.WaitProperty("Exists", false);
 
    //If closing failed, terminate the process. 
    if(isClosed == false){ 
      p.Terminate();
      Log.Message("Closing all open excell documents..");
    }    
}

  var app = Sys.OleObject("Excel.Application");
      
  var book = app.Workbooks.Open(filename);
  var sheet = book.Sheets(module);
  app.DisplayAlerts = false;
  
  var cellVal = sheet.Cells(rowIndex, colIndex).value;
  Log.Message(sheet.Cells(rowIndex, colIndex-1).value + ":"+ sheet.Cells(rowIndex, colIndex).value);
  
  app.Quit();
  return cellVal;
}

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CSV Read 
// Created By: Samitha  Created On : 09/02/2014
//  Read data from CSV file for given unique ID in first column. Returning data set
//  Please create your module level function with corresponding .csv file in \WorkstationData\\DDT\\ScriptData\\
//  Each module owners/script developers should responsible to maintain data csv files in SVN.

//ex: for casset marking we have CassetteMarkingData.csv. You have to rename function CSVDataDriverCM(UID) and keep it in application specific function library. 
//All other workstation we do same way 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function CSVDataDriver(UID)
{
 //var UID="TPW"; Testing
  
  var Driver;
  Log.Message("Reading data from csv file..");
  
  // Creates the driver using ACEDriver
  var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\Config\\AppConfig.csv";
  Driver = DDT.CSVDriver(filename); 
  
  // Iterates through records
  RecNo = 0;
  var dataSet = new Array();
  while (! Driver.EOF() ) 
  {
    arrDataSet = ProcessData(UID); // Processes data for given UID
    Driver.Next(); // Goes to the next record
  }
  
  // Closing the driver
  DDT.CloseDriver(Driver.Name);
  return arrDataSet;
  
  //Read data for given UID
  function ProcessData(UID)
  {
    var i;   
      for(i = 0; i < DDT.CurrentDriver.ColumnCount; i++)
      {
        if(DDT.CurrentDriver.Value(0)==UID) 
        {
        Log.Message(DDT.CurrentDriver.ColumnName(i) + ": " + aqConvert.VarToStr(DDT.CurrentDriver.Value(i)));
        dataSet[i] = aqConvert.VarToStr(DDT.CurrentDriver.Value(i)); 
        }
      }   
    RecNo = RecNo + 1; 
    return dataSet;
  } 

} 
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CSV Read  
// Created By: Samitha  Created On : 09/02/2014
//  Read data from CSV file for given Column name and unique ID. Returning value in matching cell.
//  Please create your module level function with corresponding .csv file in \WorkstationData\\DDT\\ScriptData\\
//  Each module owners/script developers should responsible to maintain data csv files in SVN.

//ex: for casset marking we have CassetteMarkingData.csv. You have to rename function getValueFromCSVCM(ColumnName, UID) and keep it in application specific function library. 
//All other workstation we do same way 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
function getValueFromCSV(ColumnName, UID)
{ 
   var CSVDataDriverPath =  ProjectSuite.Path + "\WorkstationData\\DDT\\Config\\AppConfig.csv";
    Log.Message(CSVDataDriverPath);
   //Open CSVDriver
   var CSVDataDriver = DDT.CSVDriver(CSVDataDriverPath);
   
   var str = 1, col = 0, RecNo = 0, recordID = 0;
  
   //Get Test Data Record ID   
    recordID = getRowID(UID); // return rowID for given UID
    
   
   //Go to the required row (it is equal to the current test number)
   CSVDataDriver.First();
   while (!CSVDataDriver.EOF() && str < recordID)
   {
      str++;
      CSVDataDriver.Next(); 
   }
   
   //If the end of file is reached and appropriate test number is not found   
   if (CSVDataDriver.EOF() == true)
   {
      Log.Message("Test number does not exist");
      //Close CSVDriver
      DDT.CloseDriver(CSVDataDriver.Name);
      return null;
   }
    
   //Go to the required column (it is equal to Parameter Name)  
   while (col!=CSVDataDriver.ColumnCount && 
		CSVDataDriver.ColumnName(col) != ColumnName)
   {
      col++;
   }
   //If all columns are checked and appropriate column name is not found
   if (col >= CSVDataDriver.ColumnCount)
   {
      Log.Message("Parameter name does not exist");
      //Close CSVDriver
      DDT.CloseDriver(CSVDataDriver.Name);
      return null;
   }

   var returnValue = CSVDataDriver.Value(ColumnName);
   Log.Message("Return " + CSVDataDriver.ColumnName(col) + ": " + (returnValue));   

   //Close CSVDriver
   DDT.CloseDriver(CSVDataDriver.Name);
   
   return returnValue;
   
   //Return record number for given UID
  function getRowID(UID)
  {
    var rowID
    while (! CSVDataDriver.EOF() ) 
    {     
        if(CSVDataDriver.Value(0)==UID) 
        {
          rowID = RecNo + 1;   
          Log.Message("UID: '" + UID + "' found in records row ID: " + rowID);
          return rowID;
        }
        else{
          CSVDataDriver.Next(); // Goes to the next record
        }         
    RecNo = RecNo + 1; 
	  }
  }
}

 function compareArraysWithSort(array1, array2) {
 
    array1.sort();
    array2.sort();
    
    // if the other array is a falsy value, return
    if (!array1 || !array2)
        return false;

    // compare lengths - can save a lot of time 
    if (array1.length != array2.length)
        return false;

    for (var i = 0; i< array1.length; i++) {
       if (array1[i] != array2[i]) { 
          return false;   
       }           
    }       
    return true;
}   

 function compareArrays(array1, array2) {
    
    // if the other array is a falsy value, return
    if (!array1 || !array2)
        return false;

    // compare lengths - can save a lot of time 
    if (array1.length != array2.length)
        return false;

    for (var i = 0; i< array1.length; i++) {
       if (array1[i] != array2[i]) { 
          return false;   
       }           
    }       
    return true;
}   



/************************************************************************

 Author: Chathura Deniyawatta
 DateCreated: 11/20/2014 
  
 [Purpose]:
 Read XML file & return the Text value
 
 [Parameter]:
 Node: node name for the Text
 
 Ex: popupTitle
 
 [Return]
 Message String
 
 *************************************************************************/


function getStrText(node)
{
  var Doc, s, Nodes, ChildNodes, i, Node;
  
  // for MSXML 6: 
  Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

  Doc.async = false;
 
  // Load data from a file 
  
  var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\Languages\\" + Properties.LAN_VERSION + ".xml";
  Doc.load(filename);
  
  // Report an error, if, for instance, the markup or file structure is invalid 
  if(Doc.parseError.errorCode != 0)
  {
    s = "Reason:\t" + Doc.parseError.reason + "\n" +
        "Line:\t" + aqConvert.VarToStr(Doc.parseError.line) + "\n" + 
        "Pos:\t" + aqConvert.VarToStr(Doc.parseError.linePos) + "\n" + 
        "Source:\t" + Doc.parseError.srcText;
    // Post an error to the log and exit
    Log.Error("Cannot parse the document.", s); 
    return;
  }
  
  // Use an XPath expression to obtain a list of "control" nodes 
  Nodes = Doc.selectNodes("//" + node);
  
  // Process the node
  for(i = 0; i < Nodes.length; i++)
  {
    // Get the node from the collection of the found nodes 
    Node = Nodes.item(i);
    // Get child nodes 
    ChildNodes = Node.childNodes;
    // return child node
    return ChildNodes.item(i).text
  } 

}

/************************************************************************

 [Purpose]: Same Like Find_available_object_with_timeout() but findsAll
 
 [Parameters]: PropArray, ValuesArray and the Properties.TIME_OUT_FOR_FINDING_OBJECT
 
 [returns]:  array of objects or null
  
 Author: Swathi
 *************************************************************************/
 
function FindAll_available_object_with_timeout(PropArray, ValuesArray, _depth){
  
  //default arguments
  var timeout = Properties.TIME_OUT_FOR_FINDING_OBJECT || 30000
  PropArray = PropArray || "idStr";
  _depth = _depth || 1000;
  
      
  //handle single string or array
  if(typeof(PropArray) == "string"){
    PropArray = [PropArray, "Visible"];
    ValuesArray = [ValuesArray, "True"];
  } else if (typeof(PropArray == "Variant Array")){
    PropArray.push("Visible");
    ValuesArray.push("True");
  } else {
    Log.Message("FindAll_visible_object_with_timeout() error");
    return null
  }

  //find the object with given time out
  Sys.Refresh();
  var page = CommonVars.page;
  count=0;
  while(count < 3){   
    count = count+1;
    var obj = page.FindAll(PropArray, ValuesArray, _depth);
        obj = (new VBArray(obj)).toArray();
    if(obj.length > 0){  
          return obj
    } else {
      Delay(timeout * (count / 6)); // given 60 sec: 10/60, 20/60, 30/60
    }
  }
  return null; 
}

/************************************************************************

 [Purpose]: Read from XML data file
 
 [Parameters]: ColumnName(string) and UID(string or number)
 
 [returns]: return the value from XML data file
  
 Author: Ramesh/David
 *************************************************************************/
function xmlTagReader(ColumnName, UID)
{
  var Doc, s, Nodes, ChildNodes, i, Node;
  
  // Create a COM object 
  // If you have MSXML 4: 
  //Doc = Sys.OleObject("Msxml2.DOMDocument.4.0");
  // If you have MSXML 6: 
  Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

  Doc.async = false;
  
  // Load data from a file
  // We use the file created earlier
 var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\ScriptData\\TestData\\" + Properties.description + "Data.xml";
 Doc.load(filename);
  // Report an error, if, for instance, the markup or file structure is invalid 
  if(Doc.parseError.errorCode != 0)
  {
    s = "Reason:\t" + Doc.parseError.reason + "\n" +
        "Line:\t" + aqConvert.VarToStr(Doc.parseError.line) + "\n" + 
        "Pos:\t" + aqConvert.VarToStr(Doc.parseError.linePos) + "\n" + 
        "Source:\t" + Doc.parseError.srcText;
    // Post an error to the log and exit
    Log.Error("Cannot parse the document.", s); 
    return;
  }
  
  //Use an XPath expression to obtain a list of "control" nodes with the "Checkboxes" namespace 
  Nodes = Doc.selectNodes("//Order");

    // Process the node
    for (i = 0; i < Nodes.length; i++)
    {
        // Get the node from the collection of the found nodes 
        Node = Nodes.item(i);
        // Get child nodes 
        ChildNodes = Node.childNodes;
        for (j = 0; j < ChildNodes.length; j++)
        {
            if (ChildNodes.item(j).text == aqConvert.VarToStr(UID))
            {
                var currentParentNode = ChildNodes.item(j).parentnode;
                for (j = 0; j < currentParentNode.ChildNodes.length; j++)
                {
                    if (ChildNodes.item(j).nodename == aqConvert.VarToStr(ColumnName))
                    {
                        Log.Message("Found " + ChildNodes.item(j).text);
                        return ChildNodes.item(j).text;
                    }
                }
            }
        }

    }
}

function createObject(parent) {
  function TempClass() {}
  TempClass.prototype = parent;
  var child = new TempClass();
  return child;
}

function mouseClickInPlace(){
  var x = Sys.Desktop.MouseX;
  var y = Sys.Desktop.MouseY;
  Sys.Desktop.MouseDown(1, x, y);
  Sys.Desktop.MouseUp(1, x, y);
}


/************************************************************************
Author: Samitha Karunaratne

[Purpose]
To identify client browser info at the _begin 
 
[Return]
No Return, initialize Properties.TestReporting

Note: this function calling at _begin 
 *************************************************************************/
function getBrowserInfo()
{    
  var objBrowser = Sys.FindChild("ProcessName", Properties.BROWSER);// Properties.BROWSER will be initiated at the getEnvSettingsForCurrentProject()
  if (!objBrowser.Exists){
    Browsers.Item(Properties.BROWSER).Run();  
    var objBrowser = Sys.FindChild("ProcessName", Properties.BROWSER);  
    objBrowser.BrowserWindow(0).Minimize();   
    Delay(wait_time_short);
  }  
  Properties.BrowserInfo = objBrowser.ProcessName +" "+ objBrowser.FileVersionInfo.MajorPart;   
}



/************************************************************************
Author: Chathura Deniyawatta

[Purpose]
Return the HexColor Code of a object (Background Color)

[Parameter]
Object
 
[Return]
Color Code

 *************************************************************************/
 
 function getObjectColor(obj){

  //get numeric value for the color.
  try {
      var wControl = obj;
      } catch (e) {
      Log.Warning("getObjectColor(), object does not exists " + e.description) ;
      return false; 
  }
  
  var vBKColor = getBKColor(wControl.Picture());
  var attrs = Log.CreateNewAttributes();
  attrs.BackColor = vBKColor; 
  var hexColorCode = attrs.BackColor;
  
  //Log the color code
  Log.Message(hexColorCode.toString(16))
  //return the hex code for the color
  return hexColorCode.toString(16)  
  
   //Funtion return the HexColor of a object 
 function getBKColor(picObj)
{
    var colors = new Array();
    var maxColor = 0;
    var maxColorCount = 0;
  
    for (var widthId = 0; widthId < picObj.Size.Width; widthId += 3) {
      for (var heighId = 0; heighId < picObj.Size.Height; heighId += 3) {
        var currentPix = picObj.Pixels(widthId, heighId)
        if (null == colors[currentPix]) {
          colors[currentPix] = 0;
        }
        colors[currentPix]++;
        if (colors[currentPix] > maxColorCount) {
          maxColorCount = colors[currentPix];
          maxColor = currentPix;
        }
      }
    } 
    return maxColor;
  } 
}

/****************************************************************************/
function verify_User(Username, Rolename) {
    try {
        var objTexttable = CommonFuncs.Find_available_object_with_timeout(["ClrClassName", "Name"], ["DataGrid", "dgUsers"], _depth);
        var objRowCount = objTexttable.RowCount;
        for (var i = 1; i < objRowCount; i++) {
            if (objTexttable.Cell(i, 0).contentText == Username && objTexttable.Cell(i, 1).contentText == Rolename) {
                Log.Message(Username + " " + "Created successfully");
                return true;
            }
        }
        return false;
    } catch (e) {
        Log.Warning("verify_User() catch error, " + e.description);
        return false;
    }
}