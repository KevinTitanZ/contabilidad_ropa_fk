<?php
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "flutter_db";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8mb4");
} catch (mysqli_sql_exception $e) {
    http_response_code(500);
    echo "Conexión fallida: " . $e->getMessage();
    exit();
}