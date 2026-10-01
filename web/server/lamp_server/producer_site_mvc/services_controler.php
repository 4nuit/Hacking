<?php

// PHP_INT_MIN et PHP_INT_MAX sont disponibles seulement depuis PHP 4.4.0
$PHP_INT_MAX = 1000000;
$PHP_INT_MIN = -$PHP_INT_MAX;

// Controler
function init_values(&$min, &$max, &$sum, &$nbe) {
	global $PHP_INT_MIN;
	global $PHP_INT_MAX;
	$max = $PHP_INT_MIN;
	$min = $PHP_INT_MAX;     
	$sum = 0;                 
	$nbe = 0;
}

function update_values(&$min, &$max, &$sum, &$nbe, $esal) {
	$min = min($esal,$min);
	$max = max($esal,$max);   
	$sum += $esal;            
	$nbe++;
}

function get_time() {
	$temps = explode(' ', microtime());     
	return $temps[1] + $temps[0];
}

?>
