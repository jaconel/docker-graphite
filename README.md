## Graphite + Carbon

An all-in-one image running graphite and carbon-cache.

This image contains a sensible default configuration of graphite and
carbon-cache. Starting this container will, by default, bind the the following
host ports:

- `80`:   the graphite web interface
- `2003`: the carbon-cache line receiver (the standard graphite protocol)
- `2004`: the carbon-cache pickle receiver
- `7002`: the carbon-cache query port (used by the web interface)

With this image, you can get up and running with graphite by simply running:

    docker run -d jaconel/graphite

You can log into the administrative interface of graphite-web (a Django
application) with the username `admin` and password `admin`. These passwords can
be changed through the web interface.

### Data volumes

Graphite data is stored at `/var/lib/graphite/storage/whisper` within the
container. If you wish to store your metrics outside the container (highly
recommended) you can use docker's data volumes feature. For example, to store
graphite's metric database at `/data/graphite` on the host, you could use:

    docker run -v /data/graphite:/var/lib/graphite/storage/whisper \
               -d jaconel/graphite

If you pre-create these directories on the host, ensure that the permissions are correct, 
else no data will be written.

## Environment 

The following environmental varaibles are supported by the container.

| Env                        | default   | Description |
| GRAPHITE_DEBUG             | false     | Whether or not to run Graphite in debug mode|
| GRAPHITE_TIME_ZONE         | UCT       | The timezone in which Graphite will display data |
| GRAPHITE_MEMCACHE_HOST     | *not set* | A comma-delimited list of memcace hosts |
| GRAPHITE_DOCUMENTATION_URL | *not set* | The url to custom documentation for your Graphite instance |
| GRAPHITE_SMTP_SERVER       | *not set* | The SMPT Server host |
| GRAPHITE_SECRET_KEY        | ""        | The secret key to use for Graphite Django app |

### Technical details

By default, this instance of carbon-cache uses the following retention periods
resulting in whisper files of approximately 2.5MiB.

    10s:8d,1m:31d,10m:1y,1h:5y

