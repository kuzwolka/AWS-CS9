from fastapi import FastAPI
from fastapi.responses import FileResponse

app = FastAPI()

@app.get("/")
async def welcome():
    return {
        "message": "hello all"
    }

@app.get("/news")
async def news():
    return "뉴스 테스트 페이지"

@app.get("/blog")
async def blog():
    return FileResponse("blog/index.html")