# inventory-info-infra
# Radhey
<h2>Setting up the Infrastructure in GCP using Terraform</h2>
</br>

<h1 text-align: "center">On Cloud Build</h1>

<h2>PreProcess:</h2>

1. Enable following google APIs using the url:  https://console.cloud.google.com/apis/library

         i.  Secret Manager
        ii.  Cloud Sql
       iii.  Memory Store
        iv.  App Engine Admin Api
         v.  Cloud Functions Api
        vi.  Cloud Scheduler
       vii.  Cloud Build
       viii. Cloud Storage
       ix.   Serverless VPC Access API
        x.   Cloud SQL Admin API
       xi.   Network Services API
       xii.  Cloud Resource Manager API
    
2. Go to IAM console there you will find a service account like

        <service-account-id>@cloudbuild.gserviceaccount.com
   Add following roles in it:

       i.    App Engine Deployer
       ii.   Cloud Build Service Account
       iii.  Cloud Functions Admin
       iv.   Cloud Functions Developer
       v.    Cloud Scheduler Admin
       vi.   Cloud SQL Admin
       vii.  Compute Network Viewer
       viii. Security Reviewer
       ix.   Service Account User
       x.    Cloud Memorystore Redis Admin
       xi.   Secret Manager Admin
       xii.  Secret Manager Secret Accessor
       xiii. Serverless VPC Access Admin
       xiv.  Storage Admin

<h2>Process:</h2>

1.  Connect following git repositories in the Cloud build using this process:

        i.    Click on the url https://console.cloud.google.com/cloud-build/triggers?project=location-inventory-info-test
        ii.   Click on Connect Repository and select following git repositories for cicd process:
                    a) Terraform Code Repo
                    b) API Repo
                    c) Web App Repo
        iii.  Skip step 4 for creating a push trigger.

2. Create Trigger for Terraform repo, Few thing for taking care about:

         i.    Just ensure that in build configuration option you choose cloud build configuration file.
         ii.   In Source option, Update the branch from which you want to deploy.
         iii.  In Substitution Variable, Add variable named  BRANCH_NAME = dev/prod

3. We need to create a bucket for storing state. Follow these steps:

        i.  Go to storage in Console and create a bucket.
        ii. In the terraform repository, update the same bucket name in the file backend.tf in environments/`<dev/prod>` directory.

4. Update variables in terraform.tfvars file.

5. Ensure that in the following files the bucket name is unique:

       i.   auto-start-db-function.tf       at line no 2
       ii.  auto-stop-db-function.tf        at line no 2
       iii. auto-create-redis-function.tf   at line no 2
       iv.  auto delete-redis-function.tf   at line no 2
       v.   auto-update-redis-function.tf   at line no 2

6. Cloud Scheduler only works when App Engine application is created, So for that just go to the url https://console.cloud.google.com/appengine and follow the given steps in console. 

7.  Now Push the code and cloud build should start creating the infrastructure.  

8.  Before Pushing API code, review the file deploy-api.sh in script derectory. Some of the fields need to be updated.
    </br>
    </br>
    </br>

<h1 text-align: "center">On Local System</h1>


<h2>PreProcess:</h2>

1. We have to create a Service Account to run the Terraform commands. We have to ways to do it:
    <h4>Console :</h4>
       i. Login to console and Go in the IAM section.

      ii. In Service Account section, create a new one, give it following Roles: 
      
                      -  Project's Owner Role
                      -  Cloud SQL Admin
                      -  Cloud Functions Admin
                      -  Storage Admin

     iii. Now we have to create a private key. This option is available in the service
          account. There are two formats of the file, P12 and json. Choose anyone of it. We will see a file is downloaded in our system Downlaods section.

      iv. Now Set an environment variable to use above file for terraform.
      
            cmd -> export GOOGLE_APPLICATION_CREDENTIALS=<private-key-path>
        
    <h4>Terminal:</h4> 
       i. Authorize the Terminal to use gcp by using this command: 

                gcloud init --skip-diagnostics --console-only

      ii. For creating a service account use the command: 

              gcloud iam service-accounts create <name>

     iii. Grant permissions to the service account using this command: 

              gcloud projects add-iam-policy-binding <Project-ID>  --member "serviceAccount:<name>@<Project-ID>.iam.gserviceaccount.com" --role "roles/owner"

      iv. For giving more roles just use above command by changing the role.
      
      v. Create Private key file using the command: 

       gcloud iam service-accounts keys create <FILE_NAME>.json --iam-account <NAME>@<PROJECT_ID>.iam.gserviceaccount.com

      vi. Now Set an environment variable to use above file for terraform.

            cmd -> export GOOGLE_APPLICATION_CREDENTIALS=<private-key-path>

2. Install Terraform using these steps: (For Windows)

      i. Open Command Prompt as administrator

      ii. Use the command to install terraform:
      
         choco install terraform
      
3. Enable following google APIs using the url:  https://console.cloud.google.com/apis/library

       i.    Secret Manager
       ii.   Cloud Sql
       iii.  Memory Store
       iv.   App Engine Admin Api
       v.    Cloud Functions Api
       vi.   Cloud Scheduler
       vii.  Cloud Build
       viii. Cloud Storage
       ix.   Serverless VPC Access API
       x.    Cloud SQL Admin API
       xi.   Network Services API
       xii.  Cloud Resource Manager API

4. Clone the github code in your workspace:
<br>

<h2>Process:</h2>

<h3>Setting up Dev environment</h3>

1. For using private IP in Cloud Sql, we need to create an inbuilt service account and give it
   following role using the console:  (https://console.cloud.google.com/iam-admin/iam)

       i.     Click on Add member
       ii.    New Member - service-<project-id-number>@service-networking.iam.gserviceaccount.com
       iii.   Role - Service Networking Service Agent

2. Go to the directory environment/dev

3. Import Default network in terraform state using command

    These four steps will be common for creating any application. For example you wanna create
    CloudSql, go to the directory and run following commands:
    
        cmd:  terraform import google_compute_network.default_network default

4. We have to give a role of Cloud-function Developer to Cloud build, for it go to settings in  cloud build in console, there we just have to enable the role of cloud function developer.

5. Set parameters in terraform.tfvars file.

6. Then just apply these commands: 

       i.    cmd:  terraform init   (will download  the dependencies)
       ii.   cmd:  terraform plan   (It will show you what this script is gonna do)
       iii.  cmd:  terraform apply

<h3>Setting up Prod environment</h3>

1. For using private IP in Cloud Sql, we need to create an inbuilt service account and give it
   following role using the console:  (https://console.cloud.google.com/iam-admin/iam)

       i.     Click on Add member
       ii.    New Member - service-<project-id-number>@service-networking.iam.gserviceaccount.com
       iii.   Role - Service Networking Service Agent

2. Go to the directory environment/prod

3. Import Default network in terraform state using command

    These four steps will be common for creating any application. For example you wanna create CloudSql, go to the directory and run following commands:

        cmd:  terraform import google_compute_network.default_network default

4. Set parameters in terraform.tfvars file.

5. Then just apply these commands: 

       i.    cmd:  terraform init   (will download  the dependencies)
       ii.   cmd:  terraform plan   (It will show you what this script is gonna do)
       iii.  cmd:  terraform apply

