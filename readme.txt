------ COMMIT 1 -------

#1 created aws account, admin, access key in vscode

#2 did terraform nextwork tutorial, uploads files to s3 bucket by talk to AWS API
- better than aws cloudformation bc terraform is cloud provider agnostic
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

-------- COMMIT 3 --------

#5 created procfile to tell elastic beanstalk how to start app
- static website: react or html only and cant execute code, or use fastapi
- dynamic website: must run code + cont listen, so needs ec2 (manual) or ec2 via elastic beanstalk (automatic) 
- the procfile launches Gunicorn (a prod web server) with ASGI worker support on port 8000, EB's default port.
- The --worker-class asgi flag enables Gunicorn's native async worker, required for FastAPI bc ASGI framework. 
- The application:app part tells Gunicorn to find the app object inside application.py.

#6 created requirements.txt
- production dependencies so AWS EB knows which versions of packages to pip install

#7 created .ebignore
- ignores things for deployment by aws eb, or else slow