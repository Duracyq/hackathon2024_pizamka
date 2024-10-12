import fastapi as fs
from twilio.rest import Client

app = fs.FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}


