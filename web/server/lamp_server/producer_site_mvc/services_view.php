<?php

function html_header() {
	echo
'<!DOCTYPE html>
<html lang="fr">
<head>
	<meta charset="utf-8"/>
	<title>tp curseurs</title>
	<link rel="stylesheet" href="style.css" media="screen" />
</head>
<body>';
}

function html_footer() {
	echo '
<p>
    <a href="http://jigsaw.w3.org/css-validator/check/referer">
        <img src="http://jigsaw.w3.org/css-validator/images/vcss" alt="CSS Valide !" />
    </a>
</p>
</body>
</html>';
}

function print_service_header($snum, $snam, $schf) {
	echo "

<div class=\"service\">
	<p>Service $snam (n°$snum, dirigé par $schf):</p>
	<table>
		<tr>
			<th>Nom</th>
			<th>Indice salaire</th>
		</tr>";
}

function print_employee($enam, $esal) {
	if (is_null($enam) && is_null($esal)) {
		return;
	}

		   echo "
		<tr>
			<td>$enam</td>
			<td>$esal</td>
		</tr>";
}

function print_service_closer($sum, $max, $min, $nbe) {
	if ($nbe < 1) {
		$max = $min = $moy = NULL;
	} else {
		$moy = $sum / $nbe;
	}
	$emp = ($nbe > 1)?"employés":"employé";

	echo "
	</table>
	<p> indice salaire: $moy (moyen), $min (minimum), $max (maximum) pour $nbe $emp</p>
</div>";
}

function print_time($txt, $time) {
	echo "
<p>$txt".round(($time),6)." secondes.</p>";	
}

function retour_menu() {
	echo "<a href='index.php'>retour menu</a>";	
}


?>
