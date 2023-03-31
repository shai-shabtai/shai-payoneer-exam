from fastapi import FastAPI, HTTPException, status, Response

counter = 0

app = FastAPI()

## Get RUL that returns the counter value (The number of POST call)
@app.get("/")
@app.get("/get")
def get_data():
    return {"The counter value is": counter}

## POST RUL that increas the counter by 1 on every call
@app.post("/post")
@app.post("/set")
def set_data():
    global counter
    counter = counter + 1
    return {"The new counter value is": counter}

## An healthcheck for the CI-CD Test
@app.get("/healthcheck")
async def get_healthchek():
    return {"status": "ok"}

## An countercheck for the CI-CD Test
@app.get("/countcheck")
async def get_count():
    return {"counter": counter}
