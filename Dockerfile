
FROM axisk/python

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

RUN mkdir -p /var/lib/graphite/storage/whisper && \
    touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index && \
    chown -R www-data /var/lib/graphite/storage && \
    chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper && \
    chmod 0664 /var/lib/graphite/storage/graphite.db && \
    cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

EXPOSE 80
EXPOSE 2003
EXPOSE 2004
EXPOSE 7002

CMD ["/usr/bin/supervisord"]
