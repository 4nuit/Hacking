docker build -t dwarf2json .
docker run -ti --rm -d dwarf2json
docker cp <container_id>:/dwarf2json/linux-image-5.10.0-23-amd64.json .
