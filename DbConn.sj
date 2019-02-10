//USEUNIT Properties

function CSVDataDriverDBConnect(UID)
{
 //var UID="TPW"; Testing
  
  var Driver;
  Log.Message("Reading data from csv file..");
  
  // Creates the driver using ACEDriver
  var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\Config\\dbConfig.csv";
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

// Access via "native" ADO objects
function ConnDBServer()
  {
    var aCon, aCmd, aRecSet, s, i;    
    
    var dbConfigDataset = CSVDataDriverDBConnect(Properties.db);
    if(!(dbConfigDataset.length > 0)){
      Log.Warning("Load(), incorrect database type provided");
    }
    var dataSource = dbConfigDataset[2];
    var uid = dbConfigDataset[3];
    var pwd = dbConfigDataset[4];
    
    if(db == "SQLServer"){
      // Creates ADO connection    
      aCon = ADO.CreateConnection();
      
      // Sets up the connection parameters      
      aCon.ConnectionString = "Provider=MSDASQL.1;Persist Security Info=True;Data Source="+dataSource+";Uid="+uid+";Pwd="+pwd;
    }
    else if (db == "Oracle"){     
      aCon = ADO.CreateConnection()
      
      // Sets up the connection parameters
      //aCon.ConnectionString = "Driver={Oracle in OraClient12Home1_32bit};Server=10.20.85.204;Uid=vantage3;Pwd=V3ntana";
      aCon.ConnectionString = "Data Source=ORASvr1;Uid=vantage3;Pwd=V3ntana";// If user name not provided in TNS in client side.
      //aCon.ConnectionString = "Data Source="+dataSource+";Pwd="+pwd;
      
    }
    else if (db == "Cache"){     
      aCon = ADO.CreateConnection()
      
      // Sets up the connection parameters      
      aCon.ConnectionString = "Data Source=CacheSvr1;Uid=_system;Pwd=CONNECT";      
      
    }
    else if (db == "MySQL"){     
      aCon = ADO.CreateConnection()
      
      // Sets up the connection parameters      
      //aCon.ConnectionString = "Provider=MSDASQL.1;Persist Security Info=False;Extended Properties='Driver=MySQL ODBC 5.3 ANSI Driver;SERVER=10.23.197.199;UID=mysqladmin;Password=test1234;DATABASE=irisqa;PORT=3306';Initial Catalog=irisqa";
      aCon.ConnectionString = "Data Source=MySQLSvr1";//;Uid=mysqladmin;Pwd=test1234"; 
      //Provider=MySQLProv;Data Source=mydb;User Id=myUsername;Password=myPassword;      
      //Log.Message("Not configured yet!");      
    }
    else{
      Log.Error("Specified Data base server is not supported!");
    }
    // Opens the connection
    aCon.Open();
    return aCon;  
  }
  
function getDbDataSet(cmdText)
{
  var aCon, aCmd, aRecSet, s, i;  
  
  //Create DB connection object
  aCon = ConnDBServer();
  
  // Creates a command and specifies its parameters
  aCmd = ADO.CreateCommand();
  aCmd.ActiveConnection = aCon; // Connection
  aCmd.CommandType = adCmdText; // Command type
  aCmd.CommandText = cmdText; // Table name  
  //aCmd.CommandText = "SELECT SoftwareVersion,CultureInfo FROM VantageInfo WHERE DisplayName='Vantage'"; // Table name  
  
  // Opens a recordset
  aRecSet = aCmd.Execute();
  if(!aRecSet.EOF){
  aRecSet.MoveFirst();

  Log.Message(aRecSet.Fields.Count + " items returned from " + Properties.db + " database");
    
  // Scans recordset  
  while (! aRecSet.EOF)
  {
    s=aRecSet.Fields.Item(0);
    for (i = 1; i < aRecSet.Fields.Count; i++)
      //dbDataSet[i]= aRecSet.Fields.Item(i).Value;
      s = s + "," +aRecSet.Fields.Item(i).Value + "\t";
    s = s + "\r\n";
    Log.Message(s);
    aRecSet.MoveNext();
  }
  
  }else{
    Log.Message("No matching records retuned from the database!");
  }
  // Outputs results  
  // Closes the recordset and connection
  aRecSet.Close();
  aCon.Close();
  return s
}

function listDbDataSystemInfo(){
  var cmdText = "select Sistema from SQLUSer.telsaServidores where SQLUSer.telsaServidores.Descripcion='Serv_CONN'";  
  //var cmdText = "select KeyCode from SQLUSer.tapOrderSlides where SQLUSer.tapOrderSlides.ID = '130'";
  var dataList = getDbDataSet(cmdText);
  Log.Message(dataList);
  return dataList;   
}

//SQL Svr test-----START-----------------
function sq1(){
  //var cmdText = "SELECT SYSDATE as TodaysDate FROM DUAL";
  //var cmdText = "SELECT * FROM V$VERSION";
  var cmdText = "SELECT SoftwareVersion,CultureInfoName FROM SystemInfo WHERE InvariantName='VANTAGE'";  
  
  var dataList = getDbDataSet(cmdText);
  Log.Message(dataList);
  return dataList;   
}

function SQLS(){
Properties.db = "SQLServer";
sq1();
}

//SQL Svr-----END-----------------


//Cache test-----START-----------------
function cc(){
 var cmdText = "select * from SQLUSer.tapOrderSlides";  
 //var cmdText = "select * from SQLUSer.tapOrderSlides where KeyCode <> \"\"";
  
  var dataList = getDbDataSet(cmdText);
  Log.Message(dataList);
  return dataList;   
}

function Cache(){
Properties.db = "Cache";
cc();
}

function getKeyCode(){
Properties.db = "Cache";
//var cmdText = "select KeyCode from SQLUSer.tapOrderSlides where SQLUSer.tapOrderSlides.SlideID = '"+slideId+"'"; //S10-1000000101;1;A;1
var cmdText = "select KeyCode from SQLUSer.tapOrderSlides where KeyCode <> '' and SQLUSer.tapOrderSlides.SlideID = 'S10-1000000101;1;A;1'";
  var keyCode = getDbDataSet(cmdText);
  Log.Message(keyCode);
  return keyCode;
}

function Cache2(){
//Properties.db = "Cache";
getKeyCode();
}

//Cache test-----END-----------------

//MySQL test-----Start-----------------
function qaz(){
  //var cmdText = "SELECT SYSDATE as TodaysDate FROM DUAL";
  //var cmdText = "SELECT * FROM V$VERSION";
  var cmdText = "SELECT * FROM mytable1";  
  
  var dataList = getDbDataSet(cmdText);
  Log.Message(dataList);
  return dataList;   
}

function mySQL(){
Properties.db = "MySQL";
qaz();
}

//MySQL test-----End-----------------



//********************************************************************************************
//Get MAX annotation ID based on the annotation type for validations
function getLastAnnotID(annottype){  
  var cmdText = "select max(entity_id) from field_data_field_annotation_type where field_annotation_type_value = '" + annottype + "'";   
  var dataList = getDbDataSet(cmdText);
  //Log.Message(dataList);
  return dataList;   
}
//Get image ID associated with latest annotation id for later verifications
function getAssociatedImageID(annotid){  
  var cmdText = "select field_image_target_id from field_data_field_image where entity_id = '" + annotid + "'";   
  var dataList = getDbDataSet(cmdText);
  //Log.Message(dataList);
  return dataList;   
}

//Get annotation color for latest annotation drawn on the canvas
function getAnnotColor(annotid){  
  var cmdText = "select field_annotation_color_value from field_data_field_annotation_color where entity_id = '" + annotid + "'";   
  var dataList = getDbDataSet(cmdText);
  //Log.Message(dataList);
  return dataList;   
}

//Get annotation fill color for latest annotation drawn on the canvas
function getAnnotFillColor(annotid){  
  var cmdText = "select field_annotation_fill_color_value from field_data_field_annotation_fill_color where entity_id = '" + annotid + "'";   
  var dataList = getDbDataSet(cmdText);
  //Log.Message(dataList);
  return dataList;   
}

//Get total number of counter annotations drawn on the image
function getTotalCounterAnnotDrawn(annotid){  
  var cmdText = "select  COUNT(annotation_target_id) from custom_counter_annotations where annotation_target_id = '" + annotid + "'";    
  var dataList = getDbDataSet(cmdText);
  //Log.Message(dataList);
  return dataList;   
}

function mySQLRead(){
Properties.db = "MySQL";
var annotid = getLastAnnotID("path");
getAnnotColor(annotid);//Only annotations other than counter annotations
getAnnotFillColor(annotid);//only for counter annotation
getAssociatedImageID(annotid);//Return image ID which associated with last drawn annotation, this to compare with image id read from GUI or page URL
getTotalCounterAnnotDrawn(annotid);//Return total number of counter annotations drawn
}


// Access via "native" ADO objects
function TestSQL_ADO2()
{
  var aCon, aCmd, aRecSet, s, i;
  // Creates ADO connection
  aCon = ADO.CreateConnection();
  // Sets up the connection parameters
  aCon.ConnectionString = "Provider=MSDASQL.1;Persist Security Info=False;Data Source=NameOfMyDSN";
  // Opens the connection
  aCon.Open();
  // Creates a command and specifies its parameters
  aCmd = ADO.CreateCommand();
  aCmd.ActiveConnection = aCon; // Connection
  aCmd.CommandType = adCmdTable; // Command type
  aCmd.CommandText = "Products"; // Table name
  // Opens a recordset
  aRecSet = aCmd.Execute();
  aRecSet.MoveFirst();
  // Obtains field names
  s = "";
  for (i = 0; i < aRecSet.Fields.Count; i++)
    s = s + aRecSet.Fields.Item(i).Name + "\t";
  s = s + "\r\n";
  // Scans recordset
  while (! aRecSet.EOF)
  {
    for (i = 0; i < aRecSet.Fields.Count; i++)
      s = s + aRecSet.Fields.Item(i).Value + "\t";
    s = s + "\r\n";
    aRecSet.MoveNext();
  }
  // Outputs results
  Log.Message("Products", s);
  // Closes the recordset and connection
  aRecSet.Close();
  aCon.Close();
}


////////////DB COnnection //////////////

function TestProc()
{
  var RecSet, Cmd;
  // Create a new object
  Cmd = ADO.CreateADOCommand();
  // Specify the connection string
  Cmd.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;" +
  "Data Source=.\SQLEXPRESS;Initial Catalog=TissueDissection_v0_7;";
  // Specify the command text (the SQL expression)
  Cmd.CommandText = "SELECT * FROM Users WHERE id=6";
  // Specify the command type
  Cmd.CommandType = cmdText;
  // Specify the parameter of the query
  //Cmd.Parameters.Items(0).Value = 1960;
  // Execute the command
  RecSet = Cmd.Execute();
  // Process the table records
  RecSet.MoveFirst();
  while (! RecSet.EOF)
  {
    if (RecSet.Fields("Year Born").Value > 0)
      Log.Message(RecSet.Fields("Author").Value, RecSet.Fields("Year Born").Value);
    RecSet.MoveNext();
  };
} 


////////////DB Close //////////////////////////