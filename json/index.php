<?php
$url='http://localhost:8080/json/sample.json';
$readJSONFile=file_get_contents($url);

$array1 = json_decode($readJSONFile,true);

if($array1["status"]==1)
{
    echo "<table border='1'>";
    echo "<tr><td>ID</td><td>TITLE</td><td>PRICE</td></tr>";
    for($i=0;$i<count($array1['data']);$i++)
    {
        echo "<tr>";
        echo "<td>".$array1['data'][$i]['id']."</td>";
        echo "<td>".$array1['data'][$i]['title']."</td>";
        echo "<td>".$array1['data'][$i]['price']."</td>";
        echo "</tr>";
    }
    echo "</table>";
}
?>