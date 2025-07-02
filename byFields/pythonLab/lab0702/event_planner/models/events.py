from pydantic import BaseModel
from typing import List

class Event(BaseModel):
    id: int
    title: str
    image: str
    description: str
    tags: List[str]
    location: str

    class Config:
        json_schema_extra = {
            "example": {
                "title": "FastAPI Study",
                "image": "https://media.hswstatic.com/eyJidWNrZXQiOiJjb250ZW50Lmhzd3N0YXRpYy5jb20iLCJrZXkiOiJnaWZcL2Zyb2ctMS5qcGciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjI5MH0sInRvRm9ybWF0IjoiYXZpZiJ9fQ==",
                "description": "my frog",
                "tags": ["frog", "charm_frog"],
                "location": "Korea"
            }
        }