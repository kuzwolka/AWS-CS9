from fastapi import APIRouter, Path, HTTPException, status, Request, Depends
from fastapi.templating import Jinja2Templates
import model

todo_router = APIRouter()
todo_list = []

templates = Jinja2Templates(directory="templates/")

#todo page
@todo_router.post("/todo")
async def add_todo(request: Request, todo: model.Todo = Depends(model.Todo.as_form)):
    todo.id = len(todo_list) + 1
    todo_list.append(todo)
    return templates.TemplateResponse("todo.html",
    {
        "request": request,
        "todos": todo_list
    })
                                      

# 전체 데이터에 대한 get(확인)
@todo_router.get("/todo", response_model=model.TodoItems)
async def retrive_todos(request: Request):
    return templates.TemplateResponse("todo.html", {
        "request": request,
        "todos": todo_list
    })
# async def show_todos() -> dict:
#     return {
#         "todos": todo_list
#     }

# 개별 데이터에 대한 GET(id 값을 사용해서 찾음)
@todo_router.get("/todo/{todo_id}")
async def get_single_todo(request: Request, todo_id: int = Path(..., title="asdf")) -> dict:
    for todo in todo_list:
        if todo.id == todo_id:
            return templates.TemplateResponse(
                "todo.html", {
                    "request": request,
                    "todo": todo
                }
            )
# async def get_single_todo(todo_id: int = Path(..., description="검색할 ID",ge=1)) -> dict: 
#     # Path의 ... -> 필수요소라는 뜻, ge => greater equal(1보다 크거나 같은 )
#     for todo in todo_list:
#         if todo.id == todo_id:
#             return {
#                 "todo": todo.item
#             }
#         raise HTTPException(
#             status_code = status.HTTP_404_NOT_FOUND,
#             detail="Wrong Access"
#         )

# # 개별 데이터 입력
# @todo_router.post("/todo", status_code=201)
# async def add_todos(todo: model.Todo) -> dict:
#     todo_list.append(todo)
#     return {
#         "message": "정상적으로 등록 완료"
#     }

# 개별 데이터 수정(PUT)
@todo_router.put("/todo/{todo_id}")
async def update_todo(todo_data: model.TodoItem, todo_id: int = Path(..., title="The ID for the todo to be updated")) -> dict:
    for todo in todo_list:
        if todo.id == todo_id:
            todo.item = todo_data.item
            return {
                "message": "todo updated"
            }
    raise HTTPException(
        status_code = status.HTTP_404_NOT_FOUND,
        detail="Wrong Access"
    )

# 개별 데이터 삭제(DELETE)
@todo_router.delete("/todo/{todo_id}")
async def delete_todo(todo_id: int = Path(..., title="The ID for the todo to be deleted")) -> dict:
    for index in range(len(todo_list)):
        todo = todo_list[index]
        if todo.id == todo_id:
            todo_list.pop(index)
            return {
                "message": "todo deleted"
            }
    raise HTTPException(
        status_code = status.HTTP_404_NOT_FOUND,
        detail="Wrong Access"
    )
# list 데이터 전체 삭제(DELETE)
@todo_router.delete("/todo")
async def delete_todo_list() -> dict:
    todo_list.clear()
    return {
        "message": "todo list deleted"
    }



person_router = APIRouter()
person_list = []

# Person Registration
@person_router.get("/person")
async def show_people() -> dict:
    return {
        "people": person_list
    }

@person_router.post("/regist")
async def add_person(person: model.Person) -> dict:
    person_list.append(person)
    return {
        "message": "정상적으로 등록 완료"
    }