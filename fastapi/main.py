import os
import pinecone
import numpy as np
from fastapi import FastAPI
from pydantic import BaseModel, Field
from openai import OpenAI
from pinecone import Pinecone
from dotenv import load_dotenv
from typing import List

app = FastAPI()
load_dotenv()
class EmbeddingRequest(BaseModel):
    isbn: str
    title: str
    description: str

class RecommendRequest(BaseModel):
    isbnList: List[str]

pc = Pinecone(api_key=os.environ.get("PINECONE_API_KEY"))
index = pc.Index("book-embedding")

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
    title_embedding = np.array(response.data[0].embedding)

    response = client.embeddings.create(
        input=review,
        model="text-embedding-3-small"
    )
    review_embedding = np.array(response.data[0].embedding)

    title_weight = 0.5
    review_weight = 0.5

    book_embedding = title_weight * title_embedding + review_weight + review_embedding

    # upsert to pinecone index
    index.upsert(
        vectors=[
            {
                "id": isbn,
                "values": book_embedding
            }
        ],
        namespace="embeddings"
    )
    return "ok"

@app.post("/recommend")
async def recommend(recommend_request: RecommendRequest):
    input_isbn_list = recommend_request.isbnList
    input_size = len(input_isbn_list)
    recommend_num = 2
    v = index.fetch(ids=input_isbn_list, namespace="embeddings")
    v = v['vectors']

    vector_sum = np.zeros((1, 1536))

    for isbn in input_isbn_list:
        vector_sum += np.array(v[isbn]['values'])

    result = vector_sum / len(input_isbn_list)
    result = np.squeeze(result)
    result = result.tolist()

    response = index.query(
        namespace="embeddings",
        vector=result,
        top_k=input_size+recommend_num,
        include_values=True
    )

    recommend_isbn_list = [match['id'] for match in response['matches']]
    filtered_recommend_isbn_list = [
        isbn for isbn in recommend_isbn_list if isbn not in input_isbn_list
    ]
    filtered_recommend_isbn_list = filtered_recommend_isbn_list[:recommend_num]
    return filtered_recommend_isbn_list