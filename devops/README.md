## Documentation

- https://monovm.com/blog/kali-rdp/
- https://www.edureka.co/blog/devops-tools
- https://github.com/sottlmarek/DevSecOps
- https://github.com/bregman-arie/devops-exercises

### Courses

- https://labs.iximiuz.com/
- https://xavki.blog/parcours-de-formation-devops/
- https://blog.stephane-robert.info/docs/homelab/packer/

## Challenges

**Modeles (Waterfall,Agile,Dev(Sec)ops)**

- https://sadservers.com
- https://tryhackme.com/r/resources/blog/devsecops-learning-path?utm_id=DevSecOps+Learning+ath
- https://owasp.org/www-project-samm/
- https://owaspsamm.org/blog/2020/10/29/comparing-bsimm-and-samm/

## Tools

### AWS, Azure, GCP

- https://github.com/lutzenfried/OffensiveCloud

### Git

- https://ohmygit.org/
- https://ohshitgit.com/
- https://amalmurali.me/posts/git-rce/
- https://github.com/adamdehaven/change-git-author/
- https://github.com/rtyley/bfg-repo-cleaner
- https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#clone-repository-using-personal-access-token

```bash
git remote set-url origin git@gitlab.com:entreprise/projet
git add
git commit
git push
git log
git reset --hard <id_commit>
git push -f
```

changer de nom
```bash
git checkout master
# Locale
git branch -m develop_test sonar_front_integration
# Distante
git push origin --delete develop_test
git push origin -u sonar_front_integration
```

ajoute une lib
```bash
git submodule add https://github.com/enterprise/imported.git external/imported
#find your lib in ~/project/external/imported
```

### Docker

- https://docs.djangoproject.com/en/dev/howto/static-files/
- https://www.ibm.com/docs/en/z-logdata-analytics/5.1.0?topic=compose-relocating-docker-root-directory

```bash
docker build --build-arg DJANGO_SECRET_KEY='SECRET_KEY' --build-arg DJANGO_DEBUG=False --build-arg DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost -t chatbox . && docker run -p 80:80 chatbox
```

### Docker Compose

```bash
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

### Elasticsearch,Logstash,Kibana

- https://static.packt-cdn.com/downloads/7154OS_ColorImages.pdf

### Keycloak

- https://static.packt-cdn.com/downloads/9781800562493_ColorImages.pdf
- https://youtu.be/UwmIrT_P2jo

### Kubernetes

- https://minikube.sigs.k8s.io/docs/start/
- https://github.com/Rolix44/Kubestroyer
- https://blog.quarkslab.com/kdigger-a-context-discovery-tool-for-kubernetes.html

### Nextcloud

[Nextcloud in Docker](./docker-compose.yml)

- https://docs.nextcloud.com/
- https://phokopi.fr/tags/nextcloud/

## Pipeline SAST: Sonarqube Integration in Jenkins

- [Memo CI/CD - Devops Exercises](https://github.com/bregman-arie/devops-exercises/blob/master/topics/cicd/README.md)
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

lancer le projet (local)

```bash
mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=$SONARQUBE_URL:$SONARQUBE_PORT -Dsonar.sourceEncoding=UTF-8 -Dsonar.sources=./ -Dsonar.sources=src
```

`groovy pipeline`

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
    node 'nodejs20'
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
