pipeline {
    agent { label 'master' }
    stages {
        stage('Build') {
            environment { 
                USER=credentials('jenkins-current-user')
                DOCKER_CREDS=credentials('jenkins-docker-credentials')
                RSTUDIO_COMMON_CREDS = credentials('jenkins-rstudio-common-creds')
            }            
            steps {
                labelledShell label: 'Building and tagging docker images...', script: '''
                    export GIT_VERSION=$(git describe --tags | sed s/v//)
                    docker build -t $USER/rreport .
                '''
                labelledShell label: 'Unit tests...', script: '''
                    echo 'skiping tests'
                    #docker-compose -f docker-compose.test.yml up
                '''                
                labelledShell label: 'Pushing images to docker registry...', script: '''
                    export GIT_VERSION=$(git describe --tags | sed s/v//)
                    echo $GIT_VERSION
                    docker tag $USER/rreport:latest $USER/rreport:$GIT_VERSION
                    docker system prune -f # remove orphan containers, volumes, networks and images
                    echo 'login to docker'
                    docker login -u $DOCKER_CREDS_USR  -p $DOCKER_CREDS_PSW
                    echo "Pushing rreport:$GIT_VERSION to docker hub"
                    docker push aabor/rreport:$GIT_VERSION
                    docker push aabor/rreport:latest
                '''
            }
            post {
                always{
                    //junit 'tests/testthat/test-reports/*.xml'
                    //cleanWs()
                    emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                        recipientProviders: [[$class: 'DevelopersRecipientProvider'], 
                        [$class: 'RequesterRecipientProvider']],
                        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
                }
            }
        }
    }
}
