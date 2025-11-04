FROM python:3.13-alpine AS api

RUN pip install --upgrade --no-cache-dir pip pipenv

RUN adduser -D worker

USER worker

WORKDIR /home/worker

ENV PATH="/home/worker/.local/bin:${PATH}"

RUN pip install "fastapi[standard]"

ARG API_VERSION

RUN echo -e "\
from fastapi import FastAPI \n\
app = FastAPI(version='${API_VERSION}') \n\
@app.get('/') \n\
def read_root():\n\
    return {'Hello': 'World from ${API_VERSION} api.'}\n\
" > api.py

EXPOSE 8000

CMD ["sh", "-c", "fastapi run api.py --host 0.0.0.0 --port 8000"]