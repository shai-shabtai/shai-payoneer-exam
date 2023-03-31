# Payoneer Assignment 
The mission is to development and deployment of a Nano service (count-service)

## Requirements
1. Create a public repository and checkout a new branch (that is not master/main)<br>
2. Develop a service called "counter-service" (I choose Python) that should maintain a web page with a counter of the amount of POST requests it served, and return the 'counter' on GET request it gets.<br>
The code should simple as possible and needs to be exposed on port 80.<be>
3. Creating a Dockerfile for building your counter-service into a docker image.<br>
4. Add a "build" stage into the pipeline script and deploy the counter-service as a docker container.<br>
5. Deployment (I choose Jenkins):<br>
  5.1 Creathing a Jenkins Pipeline Job for the service.<br>
  5.2 Set the branch name as parameter on the pipeline and deploy the service using the branch name.<br>
  5.3 Use LTS release of Jenkins and make it available on port 443 (since I don't have a domain to work with I didn't set an SSL CERT for the Jenkins)<br>
  5.4 Think of GitOps approach.<br>
6. Upon commit & push, code should pass CI/CD and reach the "prod"<br><br>
  
  
## The implementation
  ### The 'counter-service' app:
  A python script was build for "counter-service" with FastAPI as the web framework:<br><br>
  1. A GET response that returns the counter value (works on '/' or '/get'):<br>
  ![image](https://user-images.githubusercontent.com/64369709/229079334-8f7e45e2-3a59-432c-8544-05878c54898a.png)

   2. A POST call to increase the counter value by 1 on each call (works on '/post' or '/set'):
  ![image](https://user-images.githubusercontent.com/64369709/229091462-c8e8fe68-9650-4fda-944e-3f1f4bdcad42.png)<br> 
   <br>   
  
   3. A GET call after the POST updates the counter value:<br> 
  ![image](https://user-images.githubusercontent.com/64369709/229080357-00ea2fba-7dc6-4809-994a-33529f867502.png)

  4. I also set an '/healthcheck' and '/countcheck' for the "test" Stage on the Pipeline:<br>
  ![image](https://user-images.githubusercontent.com/64369709/229082579-9c733168-1fd1-4ae7-a12c-836c0320e5b2.png)

  5. I also created a Dockerfile with base-image of python-3.9 for building the "counter-service" into a docker image and created a 'pyproject.toml' file for setting the dependencies.<br>
  
  ### The Jenkins Pipeline
  I created a Jenkinsfile pipeline that received as parameters the 'branch_name' and 'github_url' and running the following stages on the pipeline:<br>
  1. Checkout/clone the Github code.<br>
  2. Build the docker image for the 'counter-service' app.<br>
  3. Running a docker container for testing the 'counter-service' app.<br>
  4. Running the 'test.sh' Bash script for checking the app is up and working properly.<br>
  5. Login to DockerHub account, tagging the docker image and push it to DockerGHub.<br>
  6. Run the 'deploy.sh' bash script that deploys with 'docker-compose' the 'counter-service' app on port 80 on the server.<br>
  ** Since I'm running the Jenkins and the Python app on the same server this seems like a fine solution for deployment, but on the "real world" I probably wouldn't do this (and this is the reason I choose to set it on the 'daply.sh' script)

  I also set a 'GitHub hook trigger' so once a PR is merged (for example from 'dev' branch to 'main' branch) the Jenkins pipeline will start to run automatically.
