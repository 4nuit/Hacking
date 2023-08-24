## Documentation

- https://github.com/bregman-arie/devops-exercises

### AWS, Azure, GCP

- https://github.com/lutzenfried/OffensiveCloud

### Elasticsearch,Logstash,Kibana

- https://static.packt-cdn.com/downloads/7154OS_ColorImages.pdf

## Pipeline Jenkins - SonarQube

[Memo CI/CD - Devops Exercises](https://github.com/bregman-arie/devops-exercises/blob/master/topics/cicd/README.md)
[Jenkins + Sonar](https://mega.nz/file/ZPVCEbjL)

- https://docs.docker.com/storage/volumes/
- https://plugins.jenkins.io/grypescanner/
- https://www.jenkins.io/blog/2017/02/07/declarative-maven-project/
- https://stackoverflow.com/questions/67833372/getting-blocked-mirror-for-repositories-maven-error-even-after-adding-mirrors
- https://www.jenkins.io/doc/book/pipeline/
- https://sonarqube.ow2.org/documentation/user-guide/user-token/
- https://docs.sonarcloud.io/advanced-setup/analysis-parameters/
- https://stackoverflow.com/questions/21323276/sonarqube-exclude-a-directory
- https://kimlyvith.medium.com/how-to-exclude-scanning-files-in-sonarqube-b2337ed3d4df

### Règles Sonar

- https://igm.univ-mlv.fr/~dr/XPOSE2012/SONAR/configuration.html
- http://www.jouvinio.net/wiki/index.php/SonarQube_gestion_r%C3%A8gles
- https://pmpl.cs.ui.ac.id/sonarqube/documentation/extend/adding-coding-rules/

ssh-keygen #copie clé publique sur serv

```git
git remote set-url origin git@gitlab.com:entreprise/projet
git add
git commit
git push
git log
git reset --hard <id_commit>
git push -f
```

créer les conteneurs et volumes
```Dockerfile
version: '3'

services:
  sonarqube:
    image: sonarqube:latest
    ports:
      - "9000:9000"
    networks:
      - my-network
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs

  jenkins:
    image: jenkins/jenkins:latest
    ports:
      - "8080:8080"
    networks:
      - my-network

networks:
   my-network:

volumes:
  sonarqube_data:
  sonarqube_extensions:
```

```bash
sudo docker-compose up -d
sudo docker ps -a --filter "ancestor=jenkins/jenkins" --format "{{.ID}}"
sudo docker exec -it --user=root $(!!) bash```
```

```bash
ip -br a | grep docker0
```

lancer le projet

```maven
mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=$SONARQUBE_URL:$SONARQUBE_PORT -Dsonar.sourceEncoding=UTF-8 -Dsonar.sources=./ -Dsonar.sources=src
```

# en pipeline groovy

```groovy
pipeline {
 agent any
 environment {
  SONARQUBE_URL = "http://172.17.0.1"
  SONARQUBE_PORT = "9000"
  SONAR_TOKEN = ""
 }
 options {
  skipDefaultCheckout()
 }
 tools {
    maven 'maven-3.9.4'
  }
 stages {
  stage('SCM') {
   steps {
    checkout scm
   }
  }
  stage('Build') {
    steps {
    sh 'mvn clean package'
    }
  }
  stage('SonarQube') {
   steps {
    sh "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=$SONARQUBE_URL:$SONARQUBE_PORT -Dsonar.sourceEncoding=UTF-8 -Dsonar.sources=./ -Dsonar.sources=src"
   }
  }
 }
```

### Libérer l'espace non utilisé

```bash
du -cs * .[^\.]* | sort -n
#38960   dpkg
#186796  apt
#924868  snapd
#23906728        docker
#25066072        total
```

```bash
lsof -p $(pidof firefox) | awk '/.mozilla/ { s = int($7/(2^20)); if(s>0) print (s)" MB -- "$9 | "sort -rn" }'
# trier par taille les fichiers ouverts par firefox
```

```bash
docker system prune -a
docker volume prune
```
