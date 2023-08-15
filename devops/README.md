## Documentation

- https://github.com/bregman-arie/devops-exercises

### AWS, Azure, GCP

- https://github.com/lutzenfried/OffensiveCloud

## Pipeline Jenkins

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

libérer l'espace non utilisé
```docker
docker system prune -a
docker volume prune
```
