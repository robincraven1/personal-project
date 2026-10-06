------ PART 1 -------

#1 created aws account, admin, access key in vscode
- .gitignore contains secrets, bots use to cryptomine on aws, or ransom data
- teams share .env secrets via AWS secrets manager, or env.example
- .gitignore contains node_modules so no heavy files stored

#2 did terraform nextwork tutorial, uploads files to s3 bucket by talk to AWS API
- better than aws cloudformation bc terraform is cloud provider agnostic
- downloaded terraform arm64 = x64
- made main.tf terraform file in project
- uses blocks, terraform registry for modules
- terraform init to prep modules, plugins so can move on
- terraform plan to review whats made/updated/destroyed
- terraform apply to acc do it
- terraform destroy to then undo that apply

------- PART 2 ---------

#3 setup environment for fastapi app
- created venv, activated it, downloaded fastapi httpx gunicorn

#4 (copied code for) fastapi app endpoints with health checks
- GET / is health check returns apps version, helps monitoring tools and load balancers 
- GET /items/{item_id} is a sample endpoint accepts a typed path parameter and optional query string.
- GET /info returns metadata about the API itself, including a list of all available endpoints.

-------- PART 3 --------

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

-------- PART 4 ---------

#8 created python test file for fastapi app
- test_health_check verifies the root endpoint returns a 200 status with the correct JSON body.
- test_read_item confirms path parameters and query strings are parsed correctly.
- test_read_item_no_query checks that optional parameters default to None when omitted.
- test_app_info validates the info endpoint returns the expected app name and endpoint list.
- run by doing python -m pytest (must activate venv first)

-------- PART 5 --------

#9 created cicd github actions to automate run tests then deploy
- created deploy.yml

#10 deploy.yml part 1 - HEADER
- on = the trigger ie when push or pull
- env = variables to be shared across repo

#11 deploy.yml part 2 - TESTING AUTOMATED
- runs-on: ubuntu-latest tells GitHub to run this job on a fresh Linux virtual machine.
- actions/checkout@v4 pulls your repository code into the runner (actual vm doing stuff) so subsequent steps can access it.
- actions/setup-python@v5 installs Python 3.11 and caches pip packages for faster runs.
- The install step installs your production dependencies from requirements.txt plus the test tools (pytest + httpx)
- The final step runs pytest to execute your test suite. If any test fails, the job fails and deployment is blocked.

#12 deploy.yml part 3 - DEPLOYMENT AUTOMATED (if tests pass, the new fastAPI goes LIVE hosted by AWS EB, if fails then old version stays LIVE, but code still pushed to github tho)
- needs: test makes this job wait for the test job to succeed before starting. If tests fail, the deploy never runs.
- The if condition ensures deployment only happens on direct pushes to main. Pull requests trigger the test job but skip deployment.
- aws-actions/configure-aws-credentials@v4 authenticates the runner using the secrets you will add to GitHub in the next step.
- aws-actions/aws-elasticbeanstalk-deploy@v1.0.0 packages your code and deploys it to Elastic Beanstalk. It auto-creates the application and environment if they do not exist yet.
- option-settings configures the IAM roles and instance type (t2.micro for free tier eligibility).

#13 added aws creds to github repo secrets section in github.com
- these aws creds are mentioned in the deploy section of cicd.

------ PART 6 -------

#14 fixing codebase so cicd tests pass bc they had failed.
- I did git push with this new cicd workflow: The tests failed, so never got to deploy stage
- Means that altho new code is now pushed to github, AWS EB still has old FASTAPI app version live, not new app.
- If tests pass, if its first time deploying, the aws-actions/aws-elasticbeanstalk-deploy@v1.0.0 action auto creates both the EB fastapi-cicd-app and the env (fastapi-cicd-env) if dont exist.
- Behind the scenes, AWS is launching a t2.micro EC2 instance, installing Python 3.11, setting up nginx as a reverse proxy, and starting my FastAPI app with Gunicorn.
- open the website by go console, eb, click url

- HOWEVER: tests failed so didnt deploy.
- Need to fix so it passes tests i think the issue is that command: pytest doesnt work. only works if venv activated then do python -m pytest

- finally fixed it after several commits and pushes to check cicd works

------- PART 7 ---------

#15 changed fastapi code, committed and pushed, to observe cicd working
- worked

------- PART 8 --------

#16 new branch to make deliberate change to test file so cicd tests fail

#17 wasnt letting me create pull req so doing another commit

#18 wasnt signed in so was able to open PR test-fail branch to main
- observed the cicd tests in the PR review
- tests failed, skips deployment (doesnt deploy in PR review anyway)
- in this scenario, at PR review, u shld not merge even if no conflicts
- why would u merge broken code to main? dumb 
- must resolve cicd tests to pass by more commits, resolve any conflicts
- then click auto merge to main, then it WILL deploy new updated app! 

------- PART 9 ---------

#19 fixed this branches deliberate cicd tests fail, then pr to merge to main, delete this branch

#20 creating staging before prod
- dev (local) -> test (local device) -> stage (irl mimic) -> prod (aws live)
- updating deploy.yml to have tests (1), deploy staging (2), deploy prod (3)
- now have ENVIRONMENT_NAME_STAGING (auto) and ENVIORNMENT_NAME_PROD (manual email approval)

#21 commited changes above in this branch (fixed deliberate cicd error now ++ created staging env)
#22 pushed this branch, pr to merge to main, passes cicd in the pr review
#23 once merged to main, main does ANOTHER cicd check passes, can delete old branch

------ PART 10 --------

#24 now only main branch exists, pulled latest now new main on github to local
#25 quick commit to main and pushed to check cicd process w tests + staging + prod
