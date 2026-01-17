FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Add the parent directory to Python path so 'app' module can be found
ENV PYTHONPATH=/app

EXPOSE 5000

CMD ["python", "app/main.py"]
