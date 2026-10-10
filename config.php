<?php
// Pobieranie danych konfiguracyjnych ze zmiennych środowiskowych Render / Aiven
$databaseServer = getenv('MYSQLHOST');
$databasePort = getenv('MYSQLPORT');
$databaseName = getenv('MYSQLDATABASE');
$databaseUsername = getenv('MYSQLUSER');
$databasePassword = getenv('MYSQLPASSWORD');

// Konfiguracja bazy danych Gibbon
$databaseType = 'mysql';
$absoluteURL = 'https://core-sn0q.onrender.com';
$installType = 'Production';

// Włączenie obsługi certyfikatu SSL dla Aiven
$databasePdoOptions = [
    PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
];

// --- JEDNORAZOWA ZMIANA HASŁA ---
try {
    $dsn = "mysql:host=$databaseServer;port=$databasePort;dbname=$databaseName;charset=utf8mb4";
    $pdo = new PDO($dsn, $databaseUsername, $databasePassword, $databasePdoOptions);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $noweHasloHash = password_hash('admin123', PASSWORD_DEFAULT);
    // Aktualizujemy hasło dla użytkownika, który ma username 'admin'
    $stmt = $pdo->prepare("UPDATE gibbonPerson SET passwordStrong = ? WHERE username = 'admin'");
    $stmt->execute([$noweHasloHash]);
} catch (\Exception $e) {
    // Ignorujemy cicho ewentualne błędy połączenia w tym locie
}
