pipeline {
    environment {
        registryRepo = "fra.ocir.io/frvabyu0plzy/deployment-demo"
        registryCredential = 'OCIR'
        gitOpsRepo = 'https://github.com/samis99/argocd-deployments.git'
        dockerImage = ''
    }

    agent any
    tools {
        maven 'maven-3.8.6'
    }

    stages {

        stage('Building image') {
            steps{
                sh 'mvn clean install -DskipTests'

                script {
                    dockerImage = docker.build(registryRepo + ":${BUILD_NUMBER}")
                }
            }
        }

        stage('Pushing to OCIR') {
            steps {
                script {
                    docker.withRegistry( 'https://fra.ocir.io', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Trigger Argo CD Deployment') {
            steps{
                script {
                    // The below will clone the repo and will be checked out to master branch by default.
                    git url: gitOpsRepo
                    sh "sed -i s+fra.ocir.io/frvabyu0plzy/deployment-demo.*+fra.ocir.io/frvabyu0plzy/deployment-demo:${BUILD_NUMBER}+g development/deployment.yaml"
                    sh "git add ."
                    sh "git commit -m 'Triggered by Jenkins Job with build number: ${BUILD_NUMBER}'"
                    sh "git push"
                }
            }
        }

        stage('Cleanup') {
            steps{
                sh "docker rmi $registryRepo:$BUILD_NUMBER"
            }
        }
    }
}
