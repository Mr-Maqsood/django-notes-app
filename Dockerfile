# -------------stage 1 : Builder-----------

FROM python:3.10-slim as builder

WORKDIR /app

RUN apt-get update && apt-get install  -y --no-install-recommends gcc libpq-dev && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --target=/install -r requirements.txt

# -------------statge 2: Final image---------

FROM python:3.10-slim

RUN adduser --disabled-password --gecos '' appuser

WORKDIR /app

COPY --from=builder /install /install


ENV PYTHONUNBUFFERED=1 PYTHONPATH="/install" PATH="/install/bin:$PATH"


COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 8000

CMD [ "gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]

