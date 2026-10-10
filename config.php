<?php
// Automatyczne pobieranie danych konfiguracyjnych z Render Environment Variables (Aiven MySQL)
$databaseServer = getenv('MYSQLHOST') ?: 'localhost';
$databasePort = getenv('MYSQLPORT') ?: '3306';
$databaseName = getenv('MYSQLDATABASE') ?: 'defaultdb';
$databaseUsername = getenv('MYSQLUSER') ?: 'root';
$databasePassword = getenv('MYSQLPASSWORD') ?: '';

// Konfiguracja bazy danych Gibbon
$databaseType = 'mysql';
$absoluteURL = 'https://core-sn0q.onrender.com';
$installType = 'Production';

// Włączenie obsługi certyfikatu SSL dla Aiven (wymagane przez zewnętrzne połączenie)
$databasePdoOptions = [
    PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
];

// --- JEDNORAZOWY AUTOMATYCZNY RESET HASŁA ADMINA ---
try {
    $dsn = "mysql:host=$databaseServer;port=$databasePort;dbname=$databaseName;charset=utf8mb4";
    $pdo = new PDO($dsn, $databaseUsername, $databasePassword, $databasePdoOptions);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $noweHasloHash = password_hash('admin123', PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("UPDATE gibbonPerson SET passwordStrong = ? WHERE username = 'admin'");
    $stmt->execute([$noweHasloHash]);
    
    // Zatrzyma działanie i wyświetli wielki komunikat potwierdzający sukces
    die("<h1 style='color:green; text-align:center; margin-top:50px;'>SUKCES! Hasło administratora zostało zmienione na: admin123</h1><p style='text-align:center;'>Teraz usuń ten blok kodu z pliku config.php i zrób ponowny git push!</p>");
} catch (\Exception $e) {
    // Jeśli coś pójdzie nie tak z połączeniem w tym ułamku sekundy, zobaczysz błąd
    echo "Błąd resetu hasła: " . $e->getMessage();
}
