<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

require_once 'DBHandler.php';

$pdo = DBHandler::getPDO();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Retrieve all products
    $sql = "SELECT * FROM Product";
    $stmt = $pdo->query($sql);
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($products);
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Add a new product
    $data = json_decode(file_get_contents("php://input"), true);
    $name = trim($data['Name']);
    $description = trim($data['Description']);
    $price = $data['Price'];
    $manufacturerId = $data['ManufacturerId'];
    $categoryId = $data['CategoryId'];
    $sql_insert = "INSERT INTO Product (Name, Description, Price, ManufacturerId, CategoryId) 
                   VALUES (:Name, :Description, :Price, :ManufacturerId, :CategoryId)";
    $stmt_insert = $pdo->prepare($sql_insert);
    $stmt_insert->bindParam(':Name', $name);
    $stmt_insert->bindParam(':Description', $description);
    $stmt_insert->bindParam(':Price', $price);
    $stmt_insert->bindParam(':ManufacturerId', $manufacturerId);
    $stmt_insert->bindParam(':CategoryId', $categoryId);
    echo $stmt_insert->execute() ? json_encode(['success' => true]) : json_encode(['success' => false]);
} elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Delete a product
    $data = json_decode(file_get_contents("php://input"), true);
    $productId = $data['ProductId'];
    $sql_delete = "DELETE FROM Product WHERE ProductId = :ProductId";
    $stmt_delete = $pdo->prepare($sql_delete);
    $stmt_delete->bindParam(':ProductId', $productId);
    echo $stmt_delete->execute() ? json_encode(['success' => true]) : json_encode(['success' => false]);
} elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Update an existing product
    $data = json_decode(file_get_contents("php://input"), true);
    $productId = $data['ProductId'];
    $name = trim($data['Name']);
    $description = trim($data['Description']);
    $price = $data['Price'];
    $manufacturerId = $data['ManufacturerId'];
    $categoryId = $data['CategoryId'];
    $sql_update = "UPDATE Product 
                   SET Name = :Name, Description = :Description, Price = :Price, ManufacturerId = :ManufacturerId, CategoryId = :CategoryId 
                   WHERE ProductId = :ProductId";
    $stmt_update = $pdo->prepare($sql_update);
    $stmt_update->bindParam(':Name', $name);
    $stmt_update->bindParam(':Description', $description);
    $stmt_update->bindParam(':Price', $price);
    $stmt_update->bindParam(':ManufacturerId', $manufacturerId);
    $stmt_update->bindParam(':CategoryId', $categoryId);
    $stmt_update->bindParam(':ProductId', $productId);
    echo $stmt_update->execute() ? json_encode(['success' => true]) : json_encode(['success' => false]);
}
