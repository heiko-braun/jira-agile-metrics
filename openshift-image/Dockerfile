# Use the standard Nginx image from Docker Hub
FROM nginx

ENV HOME=/opt/repo

# install python, uwsgi, and supervisord
RUN apt-get update && apt-get install -y supervisor uwsgi python python-pip procps vim 

# Install requirments first to make future rebuilds faster
COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Install app and binary
COPY . /opt/repo/src
RUN pip install --no-cache-dir ${HOME}/src

# Copy the configuration file from the current directory and paste 
# it inside the container to use it as Nginx's default config.
COPY ./openshift-image/nginx.conf /etc/nginx/nginx.conf

# setup NGINX config
RUN mkdir -p /spool/nginx /run/pid && \
    chmod -R 777 /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    chgrp -R 0 /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    chmod -R g+rwX /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    rm /etc/nginx/conf.d/default.conf

# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
COPY ./openshift-image/uwsgi.ini /etc/uwsgi/apps-available/uwsgi.ini
RUN ln -s /etc/uwsgi/apps-available/uwsgi.ini /etc/uwsgi/apps-enabled/uwsgi.ini

COPY ./openshift-image/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN touch /var/log/supervisor/supervisord.log

EXPOSE 8080:8080

# setup entrypoint
COPY ./openshift-image/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# access to /dev/stdout
# https://github.com/moby/moby/issues/31243#issuecomment-406879017
RUN ln -s /usr/local/bin/docker-entrypoint.sh / && \
    chmod 777 /usr/local/bin/docker-entrypoint.sh && \
    chgrp -R 0 /usr/local/bin/docker-entrypoint.sh && \
    chown -R nginx:root /usr/local/bin/docker-entrypoint.sh

# https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html
RUN chgrp -R 0 /var/log /var/cache /run/pid /spool/nginx /var/run /run /tmp /etc/uwsgi /etc/nginx && \
    chmod -R g+rwX /var/log /var/cache /run/pid /spool/nginx /var/run /run /tmp /etc/uwsgi /etc/nginx && \
    chown -R nginx:root ${HOME} && \
    chmod -R 777 ${HOME} /etc/passwd

# enter
#WORKDIR ${HOME}

# Config will be read from /config
VOLUME /config

# Outputs will be written to the /data volume 
WORKDIR /data
VOLUME /data

# Run with a headless matplotlib backend
ENV MPLBACKEND="agg"

COPY docker-scripts/batch-entrypoint.sh /batch-entrypoint.sh
RUN chmod +x /batch-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["supervisord"]
