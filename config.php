<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$databaseServer = getenv('MYSQLHOST');
$databasePort = getenv('MYSQLPORT');
$databaseName = getenv('MYSQLDATABASE');
$databaseUsername = getenv('MYSQLUSER');
$databasePassword = getenv('MYSQLPASSWORD');

$databaseType = 'mysql';
$absoluteURL = 'https://core-sn0q.onrender.com';
$installType = 'Production';

$databasePdoOptions = [
    PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
];
