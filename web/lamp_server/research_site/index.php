<!DOCTYPE html>
<html>
<body>
<h1>Affichage des publications</h1>

<script>
function loadDoc(authorname) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      printPublist(this,authorname);
    }
  };
  xhttp.open("GET", "test.xml?rand="+Math.random(), true);// le random n'est là que pour empecher la mise en cache du xml
  xhttp.send();
}

// fonction qui permet de récupérer les publications correspondant à l'auteur demandé, ou toutes les publications
function printPublist(xml,authorname) {
  var i;
  var xmlDoc = xml.responseXML;
  var liste_publis="<ul>";
  var x = xmlDoc.getElementsByTagName("article");

  // on parcourt l'ensemble des articles
  for (i = 0; i <x.length; i++) { 
    // et si l'auteur correspond (ou qu'on a demandé de tout afficher)
    if(authorname == "" || x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue == authorname){
    // on ajoute l'article à la liste
    liste_publis += "<li>" +
    x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue +
    ", " +
    x[i].getElementsByTagName("title")[0].childNodes[0].nodeValue +
    ", " +
    x[i].getElementsByTagName("journal")[0].childNodes[0].nodeValue +
    "</li>";
    }
  }
  liste_publis += "</ul>";
  // et on remplace le contenu de l'élément d'id publist par la liste que l'on vient de créer
  document.getElementById("publist").innerHTML = liste_publis;
}
</script>


<script>
// fonction qui permet d'afficher des propositions d'auteurs
function showHint(str) {
  var xhttp;
  if (str.length == 0) { 
    document.getElementById("nameHint").innerHTML = "";
    return;
  }
  xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {// 4 = request finished and response is ready, 200 = "OK"
      document.getElementById("nameHint").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "gethint.php?q="+str, true);
  xhttp.send();   
}
</script>

<!-- compléter ici ! -->

<form action="gethint.php" method="post">

<fieldset>
	Afficher : <br/>

  <input type="radio" id="puball" name="choix" onclick="getElementById('auteur').style.display='none'"/> 
  <label for="puball">toutes les publications</label><br/>
	
  <input type="radio" id="pub" name="choix" onclick="getElementById('auteur').style.display='inline'"/>
  <label for="pub">les publications d'un auteur</label>
	
  <input type="text" style="display:none" id="auteur" name="choix"/>
  <label for="auteur"> </label>

</fieldset>
  <button type="submit">Afficher les publications</button>
</form>

<p id="publist">
</p>

</body>
</html>

