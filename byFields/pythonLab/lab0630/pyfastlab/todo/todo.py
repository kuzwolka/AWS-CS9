from fastapi import APIRouter
import model

todo_router = APIRouter()
todo_list = []

@todo_router.get("/blog")
async def show_todos() -> dict:
    return {
        "todos": todo_list
    }

@todo_router.post("/todo")
async def add_todos(todo: model.Todo) -> dict:
    todo_list.append(todo)
    return {
        "message": "정상적으로 등록 완료"
    }

