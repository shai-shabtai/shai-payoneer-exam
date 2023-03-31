FROM python:3.9

WORKDIR /code
COPY ./pyproject.toml /code/pyproject.toml

ENV PYTHONPATH=${PYTHONPATH}:${PWD}

RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev

COPY ./app /code/app

CMD ["uvicorn", "app.api:app", "--host", "0.0.0.0", "--port", "5000"]
