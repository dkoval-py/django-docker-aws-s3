FROM python:3.7-slim

RUN apt update && \
    apt install -y --no-install-recommends build-essential python3-dev libpq-dev && \
    rm -rf /var/lib/apt/list/*

RUN pip install --no-cache uwsgi==2.0.19
ADD requirements.txt /
RUN pip install --no-cache -r /requirements.txt

WORKDIR /srv
ADD web_trial/ /srv

RUN python3.7 manage.py collectstatic --no-input

CMD uwsgi --http :8000 --wsgi-file robocool/wsgi.py --master --process 4 --threads 2 
