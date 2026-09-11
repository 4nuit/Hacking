<?php
include("config.php");

function connect() {
	global $HOST, $DTBS, $USER, $PASS, $PORT;
	return new \PDO("mysql:dbname=$DTBS;host=$HOST", $USER, $PASS); //PDO("pgsql:dbname=$DTBS;host=$HOST;port=$PORT", $USER, $PASS);

}

?>
