Creating the codebase:

- pip install fastapi uvicorn boto3 python-multipart

- installed FastAPI
- installed an ASGI server (Uvicorn)
- installed the AWS Python SDK (Boto3)
- installed python-multipart (for handling file uploads in FastAPI)

- AWS ORGANISATIONS
- AWS ACCOUNTS eg management, dev, test
- AWS IAM ACCOUNTS within those 

- for me i just have: one root user, one iam user

- signed in as root user on console
- created iam user (developer-workspace) with s3-full-access, creates access key
- used access key in vscode cli, which allows vscode do iam user permissions
- can modify permissions later in console as root
- can create other iam users, but must switch to it from default, in files code

- downloaded terraform arm64 = x64
- made main.tf terraform file in project
- uses blocks, terraform registry for modules
- terraform init to prep modules, plugins so can move on
- terraform plan to review whats made/updated/destroyed
- terraform apply to acc do it
- terraform destroy to then undo that apply
