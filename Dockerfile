FROM dockerfile/python

# force apt index update
RUN apt-get -y update

# Install required packages
RUN apt-get -y install python-cairo gunicorn supervisor nginx-light python2.7-dev && \
    pip install django==1.5 && \
    pip install django-tagging && \
    pip install https://github.com/graphite-project/ceres/tarball/master && \
    pip install whisper && \
    pip install Twisted==11.1.0 && \
    pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon && \
    pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web

# Add system service config
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add graphite config
ADD ./initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
ADD ./local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD ./carbon.conf /var/lib/graphite/conf/carbon.conf
ADD ./storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf

# Sane defaults for some of the config
ENV GRAPHITE_DEBUG false
ENV GRAPHITE_TIME_ZONE UCT
ENV GRAPHITE_SECRET_KEY lEdUcv91fc7yu7413cX8zY32Dg5xxDmc

# Install/Configure graphite and carbon
RUN mkdir -p /var/lib/graphite/storage/whisper 
RUN touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN chown -R www-data /var/lib/graphite/storage
RUN chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN chmod 0664 /var/lib/graphite/storage/graphite.db
RUN cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Specify the volumes
VOLUME /var/lib/graphite/storage/whisper

# Expose the ports
EXPOSE 80
EXPOSE 2003
EXPOSE 2004
EXPOSE 7002

CMD ["/usr/bin/supervisord"]
