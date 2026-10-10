<?php
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
