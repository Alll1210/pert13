<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connection.php';

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Check if the necessary data is present in the request
    if (isset($_POST["file_name"]) && isset($_POST["nama"]) && isset($_POST["description"])) {
        $fileName = $_POST["file_name"];
        $nama = $_POST["nama"];
        $description = $_POST["description"];

        $conn = connectToDatabase();

        // Update the image record in the database
        $sql = "UPDATE uploaded_images SET nama = '$nama', description = '$description' WHERE file_name = '$fileName'";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["message" => "Image details updated successfully"]);
            http_response_code(200);
        } else {
            echo json_encode(["message" => "Error updating image details in the database"]);
            http_response_code(500);
        }

        $conn->close();
    } else {
        // Data missing in the request
        http_response_code(400);
        echo json_encode(["message" => "Invalid request data"]);
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(["message" => "Method Not Allowed"]);
}
?>
