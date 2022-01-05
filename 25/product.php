<form action="" method="post" align="center">
	<h1>Enter Product Details</h1>
	Enter Product Name : <input type="text" name="pname" required></br></br>
	Enter Qunatity :<input type="number" name="quantity" required></br></br>
	category type :<input type="text" name="catt" required></br></br>
	<input type="submit" name="submit">
	<a href="index.php">Diplay Product</a>
</form>
<?php
	function insert()
	{
		if(isset($_POST['submit']))
		{
			include("conn.php");
			$pn = $_POST['pname'];
			$qty = $_POST['quantity'];
			$cd = $_POST['catt'];

			$sql= "insert into product values(null,'$pn','$qty','$cd')";
			$res = mysqli_query($mysqli, $sql);

	      if ($res === TRUE) {
	        echo "A record has been inserted.";
	      } 
	      else {
	        printf("Could not insert record: %s\n", mysqli_error($mysqli));
	      }
	      mysqli_close($mysqli);
		}
	}
	insert();
?>