pipeline {
    agent { node('jkvo_staging_db') }

    environment {
        DB_PASSWORD = credentials('staging-db-password')
    }

    stages {
        stage('build') {
            steps {
                sh "docker build -t jkvo_staging_db --build-arg DB_PASSWORD=${DB_PASSWORD} ."
            }
        }
        stage('clean') {
            steps {
                sh "(docker stop JkvoStagingDb && docker rm JkvoStagingDb) || true"
            }
        }

        stage('deploy'){
            steps {
                sh "(docker volume create jkvo_vm || true)"
                sh "docker run -p 3306:3306 -d --name JkvoStagingDb -v jkvo_vm:/jkvm jkvo_staging_db"
            }
        }
    }
}