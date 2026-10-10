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
