import os
from fastapi import FastAPI
from pydantic import BaseModel
from openai import OpenAI
from pinecone import Pinecone
from dotenv import load_dotenv

app = FastAPI()
load_dotenv()
class EmbeddingRequest(BaseModel):
    isbn: str
    title: str
    description: str

@app.post("/embed")
async def get_embedding(embedding_request: EmbeddingRequest):
    isbn = embedding_request.isbn
    title = embedding_request.title
    review = embedding_request.description

    # using openai embedding model
    client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
    response = client.embeddings.create(
        input=title,
        model="text-embedding-3-small"
    )
    title_embedding = response.data[0].embedding

    response = client.embeddings.create(
        input=review,
        model="text-embedding-3-small"
    )
    review_embedding = response.data[0].embedding

    # upsert to pinecone index
    pc = Pinecone(api_key=os.environ.get("PINECONE_API_KEY"))
    index = pc.Index("review-and-title-embedding")
    index.upsert(
        vectors=[
            {
                "id": isbn,
                "values": title_embedding,
                "metadata": {"type": "title"}
            }
        ],
        namespace="title-embeddings"
    )
    index.upsert(
        vectors=[
            {
                "id": isbn,
                "values": review_embedding,
                "metadata": {"type": "review"}
            }
        ],
        namespace="review-embeddings"
    )
    return "ok"