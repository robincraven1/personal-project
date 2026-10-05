------ COMMIT 1 -------

#1 created aws account, admin, access key in vscode

#2 did terraform nextwork tutorial, uploads files to s3 bucket
- downloaded terraform arm64 = x64
- made main.tf terraform file in project
- uses blocks, terraform registry for modules
- terraform init to prep modules, plugins so can move on
- terraform plan to review whats made/updated/destroyed
- terraform apply to acc do it
- terraform destroy to then undo that apply

------- COMMIT 2 ---------

#3 setup environment for fastapi app
- created venv, activated it, downloaded fastapi httpx gunicorn

#4 (copied code for) fastapi app endpoints with health checks
- GET / is health check returns apps version, helps monitoring tools and load balancers 
- GET /items/{item_id} is a sample endpoint accepts a typed path parameter and optional query string.
- GET /info returns metadata about the API itself, including a list of all available endpoints.


