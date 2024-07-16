<?php

include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);

// connexion BD dbperso
try
{	
    $conn = new PDO("mysql:host=$HOST;dbname=$DTBS;user=$USER;password=$PASS");
    //echo "connected";
}
catch (Exception $e)
{
    echo "<p>Unable to connect: " . $e->getMessage() ."</p>";
}

// on récupère les personnes donc le nom commence par l'entrée de l'utilisateur

$sql="select * from personne where nom_personne like :q order by nom_personne";
$stmt=$conn->prepare($sql);
$stmt->bindValue(':q',$_GET['q']."%",PDO::PARAM_STR);
$stmt->execute();

$outp = "";
while($rs = $stmt->fetch(PDO::FETCH_OBJ)) {
    $outp .= $rs->nom_personne.", ".$rs->prenom_personne.";";
}
$conn=null;

echo($outp);
?>

