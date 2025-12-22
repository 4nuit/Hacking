
## Cheatsheets

- https://ihateregex.io
- https://regex101.com

## Regexp

```py
import re

strings_to_match = [
    "toto",
    "foo",
    "bar",
    "pouet1",
    "pouet2",
    "root",
    "toor"
]

def regex_v1():
    reg = re.compile(r"pouet")
    for s in strings_to_match:
       if reg.match(s):
           print(f"Match: {s}")

def regex_v2():
    for s in strings_to_match:
       if re.match(r"pouet", s):
           print(f"Match: {s}")
```

## Compile : n operations vs 2n avec match

First on doit trouver la difference entre ces 2 codes, y'en a un ou on compile la regex au debut puis on match avec cette regex compilée
Le 2eme on match direct pattern et string sans compiler en amont.

Pour bien comprendre comment ca marche on peut aller regarder le code de la librairie ``re`` (https://github.com/blackberry/Python/blob/master/Python-3/Lib/re.py)

- voila le codeflow de ``re.match``:
```py
def match(pattern, string, flags=0):
    """Try to apply the pattern at the start of the string, returning
    a match object, or None if no match was found."""
    return _compile(pattern, flags).match(string)

# ...
def _compile(pattern, flags):
    return _compile_typed(type(pattern), pattern, flags)
# ...
def _compile_typed(text_bytes_type, pattern, flags):
    # une dizaine de ligne de code dont on se fiche
    return sre_compile.compile(pattern, flags) # Le code de sre_compile.compile parse juste la regex donc bon un peu useless de lire ca

```
On peut donc en déduire que ``_compile(pattern, flags)``  retourne un objet regex compilé (d'ou le nom assez explicite).
Grosso modo, `re.match` genere un objet regex compilé puis va appliquer la methode match dessus
