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
  background-image: url("customer.jpg");

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
	
	<div style=";padding-top: 50px; text-align: center;">
		<div class="alert alert-info" role="alert" style="height: 60px;font-size: 24px">

			<a href="signin.php">
			<button type="button" style="float: left;" class="btn btn-danger">BACK</button>
			</a>
			CREATE NEW CUSTOMER
			<a href="signin.html">
			<img src="home.png" style="float: right; height: 35px">
			</a>

		</div>
	</div>


	<form autocomplete="off" method="POST" target="_blank">	
<div class="row"  style="margin: 20px 10px 20px 10px ">
	<div class="col-md-12" style=" padding-left: 30px;padding-top: 50px;padding-bottom: 50px" >
		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
				<button type="button" name="fname" class="btn btn-dark" style="width: 200px">FIRST NAME</button>
			  </div>
			  <input type="text" class="form-control" placeholder="PLEASE ENTER THE FIRST NAME" aria-label="DESTINATION" aria-describedby="addon-wrapping">
		</div>
		<br/>

		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
				<button type="button" name="lname" class="btn btn-dark" style="width: 200px">LAST NAME</button>
			  </div>
			  <input type="text" class="form-control" placeholder="PLEASE ENTER THE LAST NAME" aria-label="ARRIVAL DATE" aria-describedby="addon-wrapping">
		</div>
		<br/>

		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
				<button type="button" name="add" class="btn btn-dark" style="width: 200px">STREET ADRESS</button>
			  </div>
			  <input type="text" class="form-control" placeholder="PLEASE ENTER THE STREET ADRESS" aria-label="DEPARTURE DATE" aria-describedby="addon-wrapping">
		</div>
		<br/>

		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
				<button type="button" name="age" class="btn btn-dark" style="width: 200px">AGE</button>
			  </div>
			  <input type="number" class="form-control" placeholder="PLEASE ENTER THE AGE" aria-label="DEPARTURE DATE" aria-describedby="addon-wrapping">
		</div>
		<br/>

		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
				<button type="button"  name="home_city" class="btn btn-dark" style="width: 200px">HOME CITY</button>
			  </div>
			  <input type="text" class="form-control" placeholder="PLEASE ENTER THE HOME CITY" aria-label="DEPARTURE DATE" aria-describedby="addon-wrapping">
		</div>
		<br/>
		<br/>


		<div class="input-group flex-nowrap">
			  <div class="input-group-prepend">
			  	<a href="travel.html">
				<button  type="submit" name="Cust" value="Submit" class="btn btn-success" style="width: 300px">CREATE NEW CUSTOMER</button>
				</a>
			  </div>
		</div>


	</div>

	</form>

<?php
		$con=mysqli_connect("localhost","root","","project");
		if(isset($_POST['Cust']))
		{
			$selQuery = "SELECT cust_id FROM customer ORDER BY cust_id DESC LIMIT 1";
			$selResult = mysqli_query($con,$selQuery);
			if($selResult->num_rows > 0)
			{
				while($row = $selResult->fetch_assoc())
				{
					$id = $row['cust_id'];
				}
				$id = $id + 1;
			}
			
			$fname = $_POST['fname'];
			$lname = $_POST['lname'];
			$age = $_POST['age'];
			$addr = $_POST['add'];
			$home_city = $_POST['home_city'];
			$loginStatus = 0;
			
			$insertQuery = "INSERT INTO customer (cust_id, cust_fname, cust_lname, age, street_address, home_city,login_status) VALUES ($id,'$fname','$lname',$age,'$addr','$home_city',$loginStatus)";
			if ($con->query($insertQuery) === TRUE) {
				echo "<script>","alert('New record created successfully')","</script>";
			} else {
				echo "Error: " . $insertQuery . "<br>" . $con->error;
			}
			$insResult = mysqli_query($con,$insertQuery);
			
		}
		
		?>

</div>

</body>


</html>