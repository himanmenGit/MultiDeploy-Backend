FROM            python:3.6.4-slim

RUN             apt-get -y update
RUN             apt-get -y dist-upgrade

RUN             apt-get -y install nginx supervisor

# File Copy
COPY            . /srv/backend
WORKDIR         /srv/backend
RUN             pip install -r requirements.txt

# Nginx Settings
RUN             rm -rf /etc/nginx/sites-enabled/*

# Copy Nginx conf
RUN             cp -f /srv/backend/.cnfong/nginx-app.conf /etc/nginx/nginx.conf

# Copy Nginx applicaion conf
RUN             cp -f /srv/backend/.config/nginx-app.conf /etc/nginx/sites-available/
RUN             ln -sf /etc/nginx/sites-available/nginx-app.conf /etc/nginx/sites-enabled/nginx-app.conf

# Copy Supervisor conf
RUN             cp -f /srv/backend/.config/supervisord.conf /etc/supervisor/conf.d/

# Stop Nginx, Run Supervisor
CMD             pkill nginx; supervisord -n

EXPOSE          80