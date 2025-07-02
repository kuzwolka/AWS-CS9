from pydantic import BaseModel, EmailStr
from typing import List, Optional
from models.events import Event

class User(BaseModel):
    email: EmailStr
    password: str
    username: str
    events: Optional[List[Event]] = None

    class Config:
        json_schema_extra = {
            "example": {
                "email": "bollack@gmail.com",
                "password": "whatthefuk",
                "username": "wikishit",
                "events": []
            }
        }

class UserSignIn(BaseModel):
    email: EmailStr
    password: str

    class Config:
        json_schema_extra = {
            "example": {
                "email": "bollack@gmail.com",
                "password": "whatthefuk"
            }
        }