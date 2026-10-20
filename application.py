from fastapi import FastAPI

app = FastAPI(title="FastAPI CI/CD Demo", version="1.0.0")


@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "1.1.0"}

@app.get("/")
def read_root():
    return {"message": "Hello from Docker Compose!", "environment": "production"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "query": q}


@app.get("/info")
def app_info():
    return {
        "app_name": "FastAPI CI/CD Demo",
        "description": "A FastAPI app deployed via GitHub Actions to AWS Elastic Beanstalk",
        "endpoints": ["/", "/items/{item_id}", "/info"],
    }