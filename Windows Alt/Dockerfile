FROM python:3.11-slim

WORKDIR /app
COPY app /app
COPY requirements.txt .
COPY certs /certs

RUN pip install -r requirements.txt
RUN mkdir /captures

EXPOSE 8080
EXPOSE 8443

CMD ["python", "app.py"]
