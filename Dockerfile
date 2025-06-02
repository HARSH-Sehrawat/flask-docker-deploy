FROM python:3.10-slim

WORKDIR /app

COPY requirement.txt requirement.txt
RUN pip install -r requirement.txt

COPY . .

CMD ["python3","flask-app.py","--host=0.0.0.0"]

