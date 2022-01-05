<!--25. Develop an application for a shopping cart with following operations:
a. Manage and display the catalog
b. Add, Update and delete the products
c. Process the shipping info
d. Stores the order info
e. Display the summary-->
<form action="product.php" align="center">
	<input type="submit" name="sub" value="product add">
	<a href="logout.php">logout</a>
</form>
<?php
function insert()
{
	include("conn.php");
	$sql = "select p.p_id,p.P_name,p.qty,c.cat_name from product p,category c where c.c_id = p.c_id";

	$res = $mysqli->query($sql);

	if($res->num_rows>0)
	{
		echo "<h2 style='color: Blue;' align='center'>Product Display<h2>";
		echo "<table border='1' cellpadding='5px' align='center'>";
		echo "<tr><th>Product Name</th><th>qty</th><th>Category Type</th><th>Update Product</th><th>Delete Product</th></tr>";
		while($row = mysqli_fetch_array($res, MYSQLI_ASSOC))
		{
			$id=$row['p_id'];
			$nm=$row['P_name'];
			$qty=$row['qty'];
			$cat=$row['cat_name'];
			echo "<tr><td>$nm</td><td>$qty</td><td>$cat</td>";
			echo "<td><a href='index.php?id=$id'>Update</a>
			</td><td><a href='index.php?did=$id'>Delete</a></td>";
			echo "</tr>";	
		}
		echo "</table>";

	}
}
insert();
function delete()
{
	include("conn.php");

	if(isset($_GET["did"]))
	{
		$id=$_GET['did'];	
		$sql = "delete from product where p_id=$id";

		$res = mysqli_query($mysqli, $sql);	 
		if ($res === TRUE) {
			echo "A record has been deleted.";
		} else {
			printf("Could not delete record: %s\n", mysqli_error($mysqli));
		}
		mysqli_close($mysqli);
	}
}	
delete();
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
		    $qt = $_POST['qty'];
			
		    $sql1 = "update product set P_name='$pna', qty='$qt' where p_id='$id'";
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

		<h3 align="center">Update Data</h3>

		<form method="POST" align="center">
		  <input type="text" name="P_name" value="<?php echo $data['P_name'] ?>" placeholder="Enter Product Name" Required>
		  <input type="number" name="qty" value="<?php echo $data['qty'] ?>" placeholder="Enter Quantity" Required>
		  <input type="submit" name="update" value="Update">
		</form>
		<?php
	}
	
}
update();
?>