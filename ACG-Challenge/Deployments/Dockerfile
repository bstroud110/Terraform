FROM python:3.8
COPY . /ACG-Kubernetes-App
WORKDIR /ACG-Kubernetes-App
RUN pip install -r requirements.txt
CMD ["python", "-u", "server.py"]
