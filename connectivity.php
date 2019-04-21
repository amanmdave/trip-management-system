<?php
function OpenCon()
 {
 $dbhost = "localhost";
 $dbuser = "root";
 $dbpass = "";
 $db = "t3";
 $conn = new mysqli($dbhost, $dbuser, $dbpass,$db) or die("Connect failed: %s\n". $conn -> error);
 
 return $conn;
 }
 
function SignIn() 
{ 
	session_start(); //starting the session for user profile page 
	if(!empty($_POST['user'])) //checking the 'user' name which is from Sign-In.html, is it empty or have some text 
	{ 
		$query = mysql_query("SELECT * FROM UserName where userName = '$_POST[user]' AND pass = '$_POST[pass]'") or die(mysql_error());
		$row = mysql_fetch_array($query) or die(mysql_error()); 
		if(!empty($row['userName']) AND !empty($row['pass'])) 
		{ 
			$_SESSION['userName'] = $row['pass']; 
			echo "SUCCESSFULLY LOGIN TO USER PROFILE PAGE..."; 
		} 
		else 
		{ 
			echo "SORRY... YOU ENTERD WRONG ID AND PASSWORD... PLEASE RETRY..."; 
		} 
	} 
} if(isset($_POST['submit'])) { SignIn(); }
 
function CloseCon($conn)
 {
 $conn -> close();
 }
   
?>
