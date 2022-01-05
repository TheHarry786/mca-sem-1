<a href="logout.php">logout</a>
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
		echo "<tr><th>Product Name</th><th>qty</th><th>Category Type</th><th>Add To Cart</th></tr>";
		while($row = mysqli_fetch_array($res, MYSQLI_ASSOC))
		{
			$id=$row['p_id'];
			$nm=$row['P_name'];
			$qty=$row['qty'];
			$cat=$row['cat_name'];
			echo "<tr><td>$nm</td><td>$qty</td><td>$cat</td>";
			echo "<td><a href='AddToCart.php?id=$id'>Add to Cart</a></td>";
			echo "</tr>";	
		}
		echo "</table>";

	}
}
insert();
?>