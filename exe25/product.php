<?php
    $conn = new mysqli("localhost","root","","test");    
  /* 
   CREATE TABLE  `product_catalog` (
	  `id` int(100) NOT NULL AUTO_INCREMENT,
	  `name` varchar(100) NOT NULL,
	   qty int(8),
	   price int(8),
	  PRIMARY KEY (`id`)
	);	
	*/
?>
 <!DOCTYPE html>
 <html lang="en">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Document</title>
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
     <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.css">
  
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.js"></script>
<script>
$(document).ready( function () {
    $('#myTable').DataTable();
} );
function myalert()
{
    return confirm("Are you sure you want to delete this record???");
}
</script>
 </head>
 <body>
 <div class="container">
    <div class="row">
        <div class="col-12 m-4">
            <?php
            $id=0;
            if($_POST)
            {
                if(isset($_POST['action']) && $_POST['action']=="INSERT")
                {
                    $name=$_POST['name'];
                    $qty=$_POST['qty'];
                    $price=$_POST['price'];
                    $sql="insert into pro_cat (name,qty,price) values('$name',$qty,'$price')";
                    $conn->query($sql);
                    ?>
                     <div class="alert alert-success alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <strong>INSERT</strong> Record inserted Sucessfully.
                    </div>
                    <?php
                }
                if(isset($_POST['action']) && $_POST['action']=="DELETE")
                {
                    $id=$_POST['id'];                    
                    $sql="DELETE FROM `pro_cat` WHERE `id`=".$id;
                    $conn->query($sql);
                    $id="";
                    $ename="";
                    $qty="";
                    $price="";
                    ?>
                     <div class="alert alert-warning alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <strong>DELETE</strong> Record Deleted Sucessfully.
                    </div>
                    <?php
                }
                if(isset($_POST['action']) && $_POST['action']=="EDIT")
                {
                    $id=$_POST['id'];
                    $name=$_POST['name'];
                    $qty=$_POST['qty'];
                    $price=$_POST['price'];
                    
                }
                if(isset($_POST['action']) && $_POST['action']=="UPDATE")
                {
                    $id=$_POST['id'];
                    $name=$_POST['name'];
                    $qty=$_POST['qty'];
                    $price=$_POST['price'];
                    //
                    $sql="UPDATE `pro_cat` SET `name`='$name',`qty`=$qty,`price`='$price' WHERE `id`=".$id;
                    $conn->query($sql);
                    $id=0;//update button text update to insert
                    ?>
                    <div class="alert alert-success alert-dismissible">
                       <button type="button" class="close" data-dismiss="alert">&times;</button>
                       <strong>UPDATE : </strong> Record updated Sucessfully.
                   </div>
                   <?php
                }
            }
            ?>
        </div>
    </div>
  
    <div class="row">
        <div class="col-12 m-4">
            <form method="POST">
                Name: <input type="text" name="name" value=<?=($id>0)?$name:''?> >
                qty: <input type="text" name="qty"  value=<?=($id>0)?$qty:''?> >
                price: <input type="text" name="price"  value=<?=($id>0)?$price:''?> >
                <?php 
                if($id>0)
                {
                    ?>
                    <input type="hidden" name="id" value=<?=$id?>>
                    <input type="hidden" name="action" value='UPDATE'>
                    <input type="submit" value="UPDATE">
                    <?php
                }
                else
                {
                    ?>
                    <input type="hidden" name="action" value='INSERT'>
                    <input type="submit" value="INSERT">
                    <?php
                }
                ?>
                
            </form>
        </div>
    </div>
    <!-- <table class="table"> -->
    <table id="myTable" class="display">
    <thead>
            <th>ID</th>
            <th>Name</th>
            <th>qty</th>
            <th>price</th>
            <th>DELETE</th>
            <th>EDIT</th>
            
    </thead>
    <tbody>
    
    <?php    
    $result=$conn->query("select * from pro_cat");
    for($i=0;$i<$result->num_rows;$i++) //row
    {
        echo "<tr>";
            $row = $result->fetch_object();    
            echo "<td>";
                echo $row->id; 
            echo "</td>";
            echo "<td>";
                echo $row->name; 
            echo "</td>";
            echo "<td>";
                echo $row->qty; 
            echo "</td>";
            echo "<td>";
                echo $row->price; 
            echo "</td>";        
            echo "<td>";
            ?>
            <form method="POST" onSubmit="return myalert();" class="form-inline" >
                <input type="hidden" name="id" value=<?=$row->id?>>
                <input type="hidden" name="action" value='DELETE'>
                <input type="submit" class="btn btn-danger" value="DELETE">
            </form>
            </td>
           <td>
            <form method="POST" class="form-inline">
                <input type="hidden" name="id" value=<?=$row->id?>>
                <input type="hidden" name="name" value=<?=$row->name?>>
                <input type="hidden" name="qty" value=<?=$row->qty?>>
                <input type="hidden" name="price" value=<?=$row->price?>>
                <input type="hidden" name="action" value='EDIT'>
                <input type="submit" class="btn btn-warning" value="EDIT">
            </form>

            <?php
            echo "</td>";    
        echo "</tr>"; }
    ?>
    </tbody>
    </table>
    </div>
 </body>
 </html>