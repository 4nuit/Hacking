<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

include("services_model_pdo.php");
include("services_view.php");
include("services_controler.php");


// Solution 2 : deux curseurs
// 1) un curseur reqs contenant les n-uplet triés par numéro de service
// 2) un curseur reqe contenant les employés d'un service 
function sol2() {

	// deux requetes dont une préparée (employés d'un service)

}

html_header();	
retour_menu();

$debut = get_time();
sol2();
$fin = get_time();

print_time('Solution 2 exécutée en ', $fin - $debut);

html_footer();

?>
