<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connection.php';

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Check if the necessary data is present in the request
    if (isset($_FILES["image"]) && isset($_POST["nama"]) && isset($_POST["description"])) {
        $image = $_FILES["image"];
        $nama = $_POST["nama"];
        $description = $_POST["description"];

        // Validate file type using exif_imagetype
        $imageType = exif_imagetype($image["tmp_name"]);
        $allowedTypes = [IMAGETYPE_JPEG, IMAGETYPE_PNG];

        if (!in_array($imageType, $allowedTypes)) {
            http_response_code(400);
            echo json_encode(["message" => "Invalid file type"]);
            exit;
        }

        // Set your upload directory
        $uploadDir = "uploads/";
        // Generate a unique name for the image
        $imageName = uniqid() . '_' . $image["name"];
        $uploadPath = $uploadDir . $imageName;

        // Move the uploaded file to the specified directory
        if (move_uploaded_file($image["tmp_name"], $uploadPath)) {
            // Image uploaded successfully, now insert details into the database
            $conn = connectToDatabase();

            // Store the complete file path in the database
            $filePath = $_SERVER['DOCUMENT_ROOT'] . '/' . 'flutter_images' . $uploadPath;

            $sql = "INSERT INTO uploaded_images (file_name, nama, description, file_path) VALUES ('$imageName', '$nama', '$description', '$filePath')";

            if ($conn->query($sql) === TRUE) {
                echo json_encode(["message" => "Image uploaded and details inserted into the database"]);
                http_response_code(200);
            } else {
                echo json_encode(["message" => "Error inserting data into the database"]);
                http_response_code(500);
            }

            $conn->close();
        } else {
            // Failed to move the file
            http_response_code(500);
            echo json_encode(["message" => "Failed to upload image"]);
        }
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