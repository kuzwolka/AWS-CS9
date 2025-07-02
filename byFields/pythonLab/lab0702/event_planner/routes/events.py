from fastapi import APIRouter, HTTPException, status, Body
from models.events import Event
from typing import List

event_router = APIRouter(
    tags=["Events"]
)

events = []

@event_router.get("/", response_model=List[Event])
async def retrieve_all_events() -> List[Event]:
    return events

@event_router.get("/{id}", response_model=Event)
async def retrive_event(id: int) -> Event:
    for event in events:
        if event.id == id:
            return event
    raise HTTPException(
        status_code = status.HTTP_404_NOT_FOUND,
        detail="ID doesn't exist!"
    )

@event_router.post("/new")
async def create_event(body: Event = Body(...)) -> dict:
    events.append(body)
    return {
        "message": "New event is created"
    }

@event_router.delete("/{id}")
async def delete_event(id: int) -> dict:
    for event in events:
        if event.id == id:
            events.remove(event)
            return {
                "message": "Event is deleted"
            }
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Provided ID doesn't exist!"
    )

@event_router.delete("/")
async def delete_all_events() -> dict:
    events.clear()
    return {
        "message": "Every event is deleted"
    }