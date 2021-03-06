

def runOnAll(Closure closure){
    for(db in ["jkvo_prod_db_01", "jkvo_prod_db_02", "jkvo_prod_db_03"]){
        node(db){
            closure();
        }
    }
}

def deployDb(){
    sh "(docker volume create jkvo_vm || true)"
    sh 'docker run -p 3306:3306 -d --name JkvoProdDb -v jkvo_vm:/jkvm -e MYSQL_ROOT_PASSWORD=$DB_PASSWORD jkvo_prod_db'
    sh "docker container ls"
}

def cleanDb(){
    sh "(docker stop JkvoProdDb && docker rm JkvoProdDb) || true"
}

def buildDb(){
    sh "rm -rf jkvoDb"
    sh "git clone https://github.com/shortrounddev/jkvoDb"
    dir("jkvoDb"){
        sh "docker build -t jkvo_prod_db ."
    }
    sh "rm -rf jkvoDb"
}

pipeline {
    agent none

    environment {
        DB_PASSWORD = credentials('prod-db-password')
    }

    stages {
        stage('build') {
            steps {
                runOnAll(this.&buildDb);
            }
        }
        stage('clean') {
            steps {
                runOnAll(this.&cleanDb);
            }
        }

        stage('deploy'){
            steps {
                runOnAll(this.&deployDb);
            }
        }
    }
}