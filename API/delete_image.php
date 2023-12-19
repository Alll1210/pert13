<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connection.php';

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Check if the necessary data is present in the request
    if (isset($_POST["file_name"])) {
        $fileName = $_POST["file_name"];

        $conn = connectToDatabase();

        // Delete the image from the server
        $uploadDir = "uploads/";
        $filePath = $uploadDir . $fileName;

        if (unlink($filePath)) {
            // Delete the image record from the database
            $sql = "DELETE FROM uploaded_images WHERE file_name = '$fileName'";

            if ($conn->query($sql) === TRUE) {
                echo json_encode(["message" => "Image deleted successfully"]);
                http_response_code(200);
            } else {
                echo json_encode(["message" => "Error deleting image from the database"]);
                http_response_code(500);
            }
        } else {
            echo json_encode(["message" => "Error deleting image from the server"]);
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