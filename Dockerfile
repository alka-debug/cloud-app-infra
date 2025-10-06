FROM python:3.12
WORKDIR /app
COPY app/ /app
RUN pip install -r requirements.txt
EXPOSE 7000
CMD ["python", "app.py"]
