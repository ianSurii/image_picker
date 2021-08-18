# image_picker
<img src="https://github.com/ianSurii/image_picker/blob/main/flutter_01.png" width="100px",height="150px">

<h1>Server code</h1>
<code>
<?php 
$return["error"] = false;
$return["msg"] = "";
//array to return

if(isset($_POST["image"] )){
    $imageId=mt_rand(1000000,9999999999).".png";

    $base64_string = $_POST["image"];
    $outputfile = "buildingPictures/".$imageId ;
    //save as image.jpg in uploads/ folder

    $filehandler = fopen($outputfile, 'wb' ); 
    //file open with "w" mode treat as text file
    //file open with "wb" mode treat as binary file
    
    fwrite($filehandler, base64_decode($base64_string));
    // we could add validation here with ensuring count($data)>1

    // clean up the file resource
    fclose($filehandler); 
}else{
    $return["error"] = true;
    $return["msg"] =  "No image is submited.";
}

header('Content-Type: application/json');
// tell browser that its a json data
echo json_encode($return);
<code>
