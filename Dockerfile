FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y tcpdump sudo && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash flaskuser && echo "flaskuser ALL=(ALL) NOPASSWD: /usr/sbin/tcpdump, /usr/bin/pkill" >> /etc/sudoers

WORKDIR /app
COPY app /app
COPY requirements.txt .
COPY certs /certs

RUN pip install -r requirements.txt
RUN mkdir /captures && chown flaskuser /captures

USER flaskuser
EXPOSE 80
EXPOSE 443

CMD ["python", "app.py"]
