<?php
include 'db_connection.php';

// Obtener datos desde Flutter
$name = $_POST['name'];
$email = $_POST['email'];

// Insertar datos en la base de datos
$sql = "INSERT INTO users (name, email) VALUES ('$name', '$email')";

if ($conn->query($sql) === TRUE) {
    echo "Registro exitoso";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>