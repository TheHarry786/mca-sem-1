<?php
	session_start();
?>
<form method="post" align="center">
	<h1 style="font-size: 50px; color: blue;">Customer Login</h1>
	<h2><b>Customer Name :</b> 
		<input type="text" name="name" required><br/><br/></h2>
	<h2 style="margin-left:70px;"><b>Password :</b> 
		<input type="password" name="ps" required></h2>
	<input type="submit" name="submit" value="Login">
	<a href="reg.php">Customer Registraion</a>
</form>

<?php
	include ("conn.php");
	if(isset($_POST['submit']))
	{
	    $username = $_POST['name'];
	    $password = $_POST['ps'];
	    //check login details
	    $sql= "Select * from customer where cust_name='$username' and password='$password'";
				
		$res = $mysqli->query($sql);
		if($res->num_rows > 0 )
		{
	        $_SESSION['username'] = $username;
	        header("location: next.php");
	        $_SESSION['success'] = "You are logged in";
	    }
	    else if($username == 'admin' && $password == 'admin')
	    {
	    	header("location: display.php");
	    }
	    else
	    {
	        header("location: index.php");
	        $_SESSION['error'] = "<div class='alert alert-danger' role='alert'>Oh snap! Invalid login details.</div>";
        }
    }
?>