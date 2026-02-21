<!DOCTYPE html>
<html>
<body>
<h1>Affichage des publications</h1>

<script>
function loadDoc(authorname) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      printPublist(this, authorname);
    }
  };
  xhttp.open("GET", "test.xml?rand=" + Math.random(), true);
  xhttp.send();
}

function printPublist(xml, authorname) {
  var i;
  var xmlDoc = xml.responseXML;
  var liste_publis = "<ul>";
  var x = xmlDoc.getElementsByTagName("article");

  for (i = 0; i < x.length; i++) { 
    if (authorname === "" || x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue === authorname) {
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
  document.getElementById("publist").innerHTML = liste_publis;
}

function showHint(str) {
  var xhttp;
  if (str.length == 0) { 
    document.getElementById("nameHint").innerHTML = "";
    return;
  }
  xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("nameHint").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "gethint.php?q=" + str, true);
  xhttp.send();   
}

function handleFormSubmit(event) {
  event.preventDefault();
  var choix = document.querySelector('input[name="choix"]:checked').value;
  var auteur = document.getElementById('auteur').value;
  if (choix === 'puball') {
    loadDoc('');
  } else if (choix === 'pub') {
    loadDoc(auteur);
  }
}
</script>

<form onsubmit="handleFormSubmit(event)">
  <fieldset>
    Afficher : <br/>
    <input type="radio" id="puball" name="choix" value="puball" onclick="document.getElementById('auteur').style.display='none';"/> 
    <label for="puball">toutes les publications</label><br/>
    <input type="radio" id="pub" name="choix" value="pub" onclick="document.getElementById('auteur').style.display='inline';"/> 
    <label for="pub">les publications d'un auteur</label>
    <input type="text" style="display:none" id="auteur" onkeyup="showHint(this.value)"/>
    <label for="auteur"></label>
  </fieldset>
  <button type="submit">Afficher les publications</button>
</form>

<p id="nameHint"></p>
<p id="publist"></p>

<script>
// Load all publications by default
loadDoc('');
</script>

</body>
</html>
