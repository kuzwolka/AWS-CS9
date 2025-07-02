from pydantic import BaseModel,field_validator
from typing import Optional, List
import re
from fastapi import Form

class Todo(BaseModel):
    id: Optional[int] = None
    item: str

    @classmethod
    def as_form(
        cls,
        item: str = Form(...)
    ):
        return cls(item=item)

#개별 데이터 업데이트 모델
class TodoItem(BaseModel):
    item: str
    class Config:
        json_schema_extra = {
            "example": {
                "item": "수정할 내용"
            }
        }

#모든 데이터에서 item만 모아서 출력하기
class TodoItems(BaseModel):
    todos: List[TodoItem]

    class Config:
        json_schema_extra = {
            "example": {
                "todos": [
                    {
                        "item": "example1"
                    },
                    {
                        "item": "example2"
                    }
                ]
            }
        }

class Address(BaseModel):
    cirt: str
    street: str

class Person(BaseModel):
    first_name: str
    last_name: str
    phone_number: str
    age: int
    address: Optional[Address] = None

    @field_validator("phone_number")
    def phone_number_must_have_10_digits(cls, v):
        match = re.match(r"0\d{9}", v)
        if (match is None) or (len(v) != 10):
            raise ValueError("Phone number must have 10 digits")
        return v
