from fastapi import FastAPI
# 파일 리턴, 다른 웹 페이지로의 redirect을 위한 import
from fastapi.responses import FileResponse, RedirectResponse
import todo

app = FastAPI()

@app.get('/')
async def welcome() -> dict:
    return {
        "message": "hello"
    }

app.include_router(todo.todo_router)

# @app.get('/test1')
# async def test1() -> str:
#     return "This is und test"

# # 파일을 보여줄 것
# @app.get('/test2')
# async def test1():
#     return FileResponse("test2/index.html")

# @app.get('/test3')
# async def test1():
#     return RedirectResponse("https://www.naver.com")