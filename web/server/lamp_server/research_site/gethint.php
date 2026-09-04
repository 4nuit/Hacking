<?php

include("config.php");
//error_reporting(E_ALL);
//ini_set('display_errors', 1);

// Connexion à la base de données dbperso
try {    
    $conn = new PDO("mysql:host=$HOST;dbname=$DTBS", $USER, $PASS);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    die("<p>Unable to connect: " . $e->getMessage() ."</p>");
}

$q = isset($_GET['q']) ? $_GET['q'] : '';

if ($q !== '') {
    $sql = "SELECT * FROM personne WHERE nom_personne LIKE :q ORDER BY nom_personne";
    $stmt = $conn->prepare($sql);
    $stmt->bindValue(':q', $q . '%', PDO::PARAM_STR);
    $stmt->execute();

    $outp = "";
    while ($rs = $stmt->fetch(PDO::FETCH_OBJ)) {
        $outp .= $rs->nom_personne . ", " . $rs->prenom_personne . "; ";
    }
    echo $outp;
}

$conn = null;
?>
