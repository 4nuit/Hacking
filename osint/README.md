## Doc

- https://anonymousplanet.org/guide.html
- https://github.com/jivoi/awesome-osint
- [https://cheatsheet.haax.fr/open-source-intelligence-osint/](https://web.archive.org/web/20240915152634/https://cheatsheet.haax.fr/open-source-intelligence-osint/)
- https://blog.volkercarstein.com/geoint_workshop_slides.pdf
- https://fuzzinglabs.com/blockchain-web3-osint-profiling-deanonymization/

## Challenges

- https://gralhix.com/list-of-osint-exercises/
- https://isfred.fr/

## Tools

- https://dorkgenius.com/
- https://app.osintracker.com/
- https://github.com/N0rz3/TraxOsint
- https://github.com/laramies/theHarvester
- https://start.me/p/xjbRK8/osint-ibis
- https://start.me/p/DPRM5o/oscar-zulu-toolbox
- https://github.com/osintambition/Awesome-Browser-Extensions-for-OSINT

### APIs & Search engines

- https://osint.sh
- https://shdn.io/
- https://recox.hackerz.space/
- https://github.com/cipher387/API-s-for-OSINT
- https://osint-opsec.fr/wpint-osint-wordpess/
- https://github.com/jakejarvis/awesome-shodan-queries


### Reverse Image Search

- https://lenso.ai/en
- https://www.reversely.ai/

#### Face Recon

- https://tinyeye.com
- https://pimeyes.com/en
- https://www.faceseek.online/

#### Geoint

- https://geohints.com/
- https://images.google.com/
- https://overpass-turbo.eu/
- https://osmlab.github.io/learnoverpass//en/
- https://www.instantstreetview.com/

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
<!--  -->


### Social

- https://webmii.com/
- https://waybien.com/
- https://www.social-searcher.com/
- https://octolens.com/blog/search-engines-for-social-media

#### Mail

- https://epieos.com/
- https://keys.openpgp.org/
- https://behindtheemail.com/
- https://www.molfar.institute/en/email-via-youtube/

#### Phone

- https://www.annu.com/
- https://roso.info/app/
- https://whatsapp.checkleaked.cc/
- https://red-security.fr/t/tutoriel-osint-numero-de-telephone/110

#### Pseudo

- https://whatsmyname.app/, https://github.com/C3n7ral051nt4g3ncy/WhatsMyName-Python
- https://github.com/sherlock-project/sherlock


#### Societes

- https://data.inpi.fr/
- https://www.pagesjaunes.fr/pagesblanches
- https://societeinfo.com/app/recherche/societes
- https://annuaire-entreprises.data.gouv.fr/entreprise

