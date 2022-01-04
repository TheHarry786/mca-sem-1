<?php
	$target_dir ="uploads/img/";
	$target_file = $target_dir . basename($_FILES["fileToUpload"] ["name"]);
	
	if(move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file))
	{
		echo "The File". htmlspecialchars( basename($_FILES["fileToUpload"]["name"])). " has been uploaded . " ;
		echo "<img src= '$target_file' >";
	}
	else
	{
		echo "please try again! Something Wrong...";
	}
	
?>
