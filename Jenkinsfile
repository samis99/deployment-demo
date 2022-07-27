pipeline {
    environment {
        registryRepo = "fra.ocir.io/frvabyu0plzy/deployment-demo"
        githubCredential = 'GITHUB'
        gitOpsRepo = 'https://github.com/samis99/argocd-deployments.git'
        dockerImage = ''
    }

    agent any

    stages {

        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build(registryRepo + ":${BUILD_NUMBER}")
                }
            }
        }

        stage('Pushing to OCIR') {
            steps {
                script {
                    docker.withRegistry( 'https://fra.ocir.io') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Trigger Argo CD Deployment') {
            steps{
                script {
                    // The below will clone the repo and will be checked out to master branch by default.
                    git credentialsId: githubCredential, url: gitOpsRepo
                    sh "cat dev/registration-service.yaml"
                    sh "sed -i s+fra.ocir.io/frvabyu0plzy/cis-registration-service.*+fra.ocir.io/frvabyu0plzy/cis-registration-service:${BUILD_NUMBER}+g dev/registration-service.yaml"
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
