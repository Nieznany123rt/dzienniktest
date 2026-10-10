<?php
require_once __DIR__ . '/config.php';

try {
    $pdo = new PDO("mysql:host=$databaseServer;port=$databasePort;dbname=$databaseName;charset=utf8mb4", $databaseUsername, $databasePassword);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $noweHasloHash = password_hash('admin123', PASSWORD_DEFAULT);
    
    $stmt = $pdo->prepare("UPDATE gibbonPerson SET passwordStrong = ? WHERE username = 'admin'");
    $stmt->execute([$noweHasloHash]);
    
    echo "Sukces! Hasło dla konta admin zostało zmienione na: admin123";
} catch (\Exception $e) {
    echo "Błąd: " . $e->getMessage();
}
