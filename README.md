# image_picker


<a href="url"><img src="https://github.com/ianSurii/image_picker/blob/main/flutter_01.png" align="left" height="600" width="300" ></a>

<h1>Server code</h1>

   
  ```php
  <?php
$return["error"] = false;

$return["msg"] = "";
 

if(isset($_POST["image"] )){<
  
    $imageId=mt_rand(1000000,9999999999).".png";
    $base64_string = $_POST["image"];
    $outputfile = "buildingPictures/".$imageId ;
    $filehandler = fopen($outputfile, 'wb' );     
    fwrite($filehandler, base64_decode($base64_string));   
    fclose($filehandler); 
}else{
    $return["error"] = true;
    $return["msg"] =  "No image is submited.";
}
header('Content-Type: application/json');
  
echo json_encode($return);
?>
```

