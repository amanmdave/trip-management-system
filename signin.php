<html>


<head>
<title>TRIP MANAGEMENT</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<style type="text/css">
body, html {
  height: 100%;
}

.bg { 
  /* The image used */
  background-image: url("signin.jpg");

  /* Full height */
  height: 100%; 

  /* Center and scale the image nicely */
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}


</style>

</head>


<body class="bg">
	<div style=";padding-top: 50px; padding-bottom: 100px;text-align: center;">
		<div class="alert alert-info" role="alert" style="height: 60px;font-size: 24px">

			
			LOGIN PAGE
		
		</div>
	</div>

<div  >
	<div class="col-md-12" style=" padding-left: 30px;padding-top: 50px;padding-bottom: 50px;  margin: 0px" >

<div style="border: 5px solid black;width: 320px;padding: 5px;background-color: white">
		<form method="POST">
		  <div  class="form-group">
		    <label for="exampleInputEmail1">USERNAME</label>
		    <input style="width: 300px; " type="text" class="form-control" id="text" aria-describedby="emailHelp" name="userEmail" placeholder="PLEASE ENTER THE USERNAME">
		  </div>
		  <div class="form-group">
		    <label class="center-block" for="exampleInputPassword1">PASSWORD</label>
		    <input style="width: 300px;" align="middle" type="password" class="form-control" id="PASSWORD" name="userPassword" placeholder="PLEASE ENTER THE PASSWORD">
		  </div>
		  	
			
			<div>
				<button style="width: 300px; " type="submit" name="custo" class="btn btn-primary">Customer Login</button>
				
			</div>
			
			<br />
			<div>
				<button style="width: 300px; " type="submit" name="admeen" class="btn btn-warning">Admin Login</button>
					
			</div>
			<hr/>
			<div>
				<button style="width: 300px; " type="submit" name="newCust" class="btn btn-success">New Customer Signup</button>
			</div>
		
		<?php 
        require_once 'dbconfig.php';
        try {
			$con=mysqli_connect("localhost","root","","project");
            // execute the stored procedure
            $sql = 'CALL proc_admin1';
            // call the stored procedure
            $q = $con->query($sql);
        } catch (PDOException $e) {
            die("Error occurred:" . $e->getMessage());
        }

				
				if(isset($_POST['newCust']))
				{
					$username = $_POST['userEmail'];
					$pass = $_POST['userPassword'];
					$selQuery = "SELECT cust_id FROM login ORDER BY cust_id DESC LIMIT 1";
					$selResult = mysqli_query($con,$selQuery);
					if($selResult->num_rows > 0)
					{
						while($row = $selResult->fetch_assoc())
						{
							$id = $row['cust_id'];
						}
						$id = $id + 1;
					}
					$login_status =1;
					
					$newQ = "INSERT INTO login (cust_id,username,password,login_status) VALUES($id,'$username','$pass',$login_status)";
					$newQ = "INSERT INTO login (cust_id,username,password,login_status) VALUES($id,'$username','$pass',$login_status)";
					$newRes = mysqli_query($con,$newQ);
					
					echo '<script type="text/javascript">','window.location = "newcustomer.php";','</script>';
				}
				if(isset($_POST['admeen'])) 
				{
					$username = $_POST['userEmail'];
					$pass = $_POST['userPassword'];
					if($username == "admin" && $pass == "admin")
					{
						echo '<script type="text/javascript">','window.location = "admin.php";','</script>';
					}
					else
					{
						echo '<script type="text/javascript">','alert("Incorrect Credentials!");','</script>';
					}
						
				}else if(isset($_POST['custo']))
				{
					$username = $_POST['userEmail'];
					$pass = $_POST['userPassword'];
					$sqlresult = "SELECT username,password FROM login";
					$result = mysqli_query($con,$sqlresult);
					if($result->num_rows>0)
					{
						while($row = $result->fetch_array())
						{
								if($row['username'] == $username && $row['password'] == $pass)
								{
									echo '<script type="text/javascript">','window.location = "details.php";','</script>';
								}
						}
					}
					else
					{
						echo '<script type="text/javascript">','alert("Incorrect Credentials!");','</script>';
					}
				}
			?>
		</form>

  </div>
</div>
</div>

</body>


</html>