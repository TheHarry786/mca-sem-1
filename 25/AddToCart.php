<a href="next.php">Back</a>
<?php
function update()
{

	include("conn.php");

	if(isset($_GET['id']))
	{
		$id = $_GET['id']; 

		$sql = "select * from product where p_id='$id'";

		$res = mysqli_query($mysqli, $sql);	
		

		$data = mysqli_fetch_array($res);

		if(isset($_POST['update'])) 
		{
		    $pna = $_POST['P_name'];
			
		    $sql1 = "update product set P_name='$pna' where p_id='$id'";
			$res1 = mysqli_query($mysqli, $sql1);

		    if($res1 === TRUE)
		    {
		    	echo "A record has been Updated.";
		        mysqli_close($mysqli); 
		        exit;
		    }
		    else
		    {
		        echo mysqli_error();
		    }    	
		}
		?>

		<h3 align="center">Buy Product</h3>

		<form method="POST" align="center">
		  <input type="text" name="P_name" value="<?php echo $data['P_name'] ?>" placeholder="Enter Product Name" Required>
		
		  <input type="submit" name="update" value="Buy">
		</form>
		<?php
	}
	
}
update();
?>