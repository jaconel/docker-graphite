import os

# Set the secret key
if "GRAPHITE_SECRET_KEY" in os.environ:
    SECRET_KEY = os.environ["GRAPHITE_SECRET_KEY"]

# Turn on debugging and restart apache if you ever see an "Internal Server Error" page
DEBUG = (os.environ["GRAPHITE_DEBUG"] == True)

# Set your local timezone (django will try to figure this out automatically)
TIME_ZONE = os.environ["GRAPHITE_TIME_ZONE"]

# Setting MEMCACHE_HOSTS to be empty will turn off use of memcached entirely
# The environmental varaible accepts a comma-delimited list of hosts
# eg. 10.0.0.1:11211,10.0.0.2:11211
if "GRAPHITE_MEMCACHE_HOST" in os.environ:
    MEMCACHE_HOSTS = os.environ["GRAPHITE_MEMCACHE_HOST"].split(",")

# Override this if you need to provide documentation specific to your graphite deployment
if "GRAPHITE_DOCUMENTATION_URL" in os.environ:
    DOCUMENTATION_URL = os.environ["GRAPHITE_DOCUMENTATION_URL"]

# Enable email-related features
if "GRAPHITE_SMTP_SERVER" in os.environ: 
    SMTP_SERVER = os.environ["GRAPHITE_SMTP_SERVER"]

