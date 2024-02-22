## Doc

- https://anonymousplanet.org/guide.html
- https://github.com/4nuit/Writeup/blob/master/2023/Flag4all/osint/2023FLAG4All-enonce_solution.pdf
- https://blog.volkercarstein.com/geoint_workshop_slides.pdf
- https://fuzzinglabs.com/blockchain-web3-osint-profiling-deanonymization/

## Tools

- https://start.me/p/xjbRK8/osint-ibis

### APIs

- https://github.com/cipher387/API-s-for-OSINT
- https://overpass-turbo.eu/
- https://www.shodan.io/
- https://osint.sh

#### Geoint

- https://geohints.com/

`overpass exemple`

```bash
[out:json];
(
  node["amenity"="bus_stop"](around:1000,47.1234,-1.2345);
  node["amenity"="parking"](around:1000,47.1234,-1.2345);
  way["highway"="residential"](around:1000,47.1234,-1.2345);
  way["natural"="tree_row"](around:1000,47.1234,-1.2345);
);
out;
```

### IP

- https://github.com/N0rz3/TraxOsint

### Pseudo

- https://epieos.com/
- https://whatsmyname.app/
- https://github.com/sherlock-project/sherlock

### Societes

- https://societeinfo.com/app/recherche/societes
- https://annuaire-entreprises.data.gouv.fr/entreprise
