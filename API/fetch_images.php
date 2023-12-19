<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connection.php';

$conn = connectToDatabase();

$sql = "SELECT file_name, nama, description FROM uploaded_images";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $imageList = array();

    while ($row = $result->fetch_assoc()) {
        $imageList[] = $row;
    }

    http_response_code(200);
    echo json_encode($imageList);
} else {
    http_response_code(404);
    echo json_encode(array("message" => "No images found."));
}

$conn->close();
?>
