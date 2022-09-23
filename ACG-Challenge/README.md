Instructions:  https://acloudguru.com/blog/engineering/cloudguruchallenge-your-resume-on-gcp

System Requirements (Build)
Here are the System Requirements for what you need to Build:

Frontend (FE):
Personal Brand / Resume website
Using (all of) HTML, CSS, and JavaScript (JS)
Feel free to use a rich template—or start with a very basic example, if you’re ambitious
Must include your name and link to your LinkedIn profile
Should ideally list you having the Associate Cloud Engineer (ACE) cert
I would also consider the Cloud Digital Leader (CDL) cert, since it’ll be paired with all this practical experience.
And I could be convinced to overlook this point (so don’t let this block you) but I do very strongly suggest ACE, in particular.
I also know this foundation will help you a lot with this challenge, because I’ve made a course for the Associte Cloud Engineer cert. (To be clear, you do NOT need to take my course or any other A Cloud Guru training to join this challenge.)
A section/page/link to describe your challenge entry (see below), including a least one architecture diagram image
Must include a visitor hit counter (via Javascript call to your own API; see below)
Hosting:
Set it up as a static site on Google Cloud Storage (GCS)
Give it any custom domain name you want (this will cost for registration) — yoursite.com (or any TLD)
You could — but don’t have to — use Cloud Domains for this ($12/year for .com)
Use Cloud DNS
Use a Global HTTPS Cloud Load Balancer (this will cost to provision)
HTTPS is definitely required
Use Cloud CDN for caching
Frontend Code/CI/CD:
Store your site code in GitHub
Use GitHub Actions or Cloud Build to republish your frontend whenever the code changes
You may want to invalidate the Cloud CDN cache on redeploy

Backend (BE):
Write some simple API code — ideally in Python — to connect to Firestore to increment the site visitor count and return the running total
Your Firestore DB should not be publicly accessible
You do not need to use Distributed Counters, but it is an option
Deploy your API as a container on Cloud Run
You might want to put this under either api.yoursite.com or yoursite.com/api, but this is not required
Code:

Store your API code in GitHub
Use Cloud Source Repositories (CSR) to mirror your API repo from GitHub
CI via Cloud Build:
Have Cloud Build trigger from Cloud Source Repositories
Even though straight to GitHub can work
Do not use GitHub Actions for this one
Build your hit counter code into a container
Ideally, do some basic unit testing
Push the container to Artifact Registry
Employ a GitOps-style approach and update the current API deployment config in another CSR repo
CD via Cloud Build:
Triggered by update to API deployment config CSR repo
Deploys specified container to Cloud Run
Stretch goal:
If you have the time and inclination, use Terraform IaC to create your setup in a blank new GCP project

Yet to build:
    Firestore
    Cloud Run
    Cloud Build
    Services - APIs for GCP items like GKE

Finished, but not fully tested:
    VPC
    Subnets
    GKE cluster (control plane only)