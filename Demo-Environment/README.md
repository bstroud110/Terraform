Important pre work that needs to be implemented in the bootstrap.sh script.

gcloud config set project playground-s-11-814f9d64

gcloud iam service-accounts keys create keys/terraform-sa-instance.json --iam-account terraform-sa@playground-s-11-814f9d64.iam.gserviceaccount.com

Creating a terraform service account in GCP
From Google Cloud console's main navigation, choose IAM & Admin > Service Accounts.
Click Create service account.
Give your service account a name. terraform-sa
Click Create.
In the roles dropdown, select Project > Owner.
Click Continue and then Done.

Need to work out creating a gcloud config for the particular GCP environment 
Authenticate with this using gcloud auth login

Copy the email address of the account so we can make a key with it:
	gcloud iam service-accounts keys create /downloads/instance.json --iam-account <SERVICE_ACCOUNT_EMAIL>
		** This needs to be updated to reflect my local env and not a vm within GCP like the labs use **
