<?php
// Poprawne pobieranie danych konfiguracyjnych ze zmiennych środowiskowych Render / Aiven
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
