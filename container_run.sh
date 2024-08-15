# This script will replace the value in the file index.html.
# By replacing the value with the contents of the environment variable,
#   we are able to specify the qotd webapi URL at runtime.
# E.g. podman run -e QOTD_API_URL="https://foo/bar/quotes/random" quay.io/donschenck/qotd-frontend:latest

sed -i "s|##QOTD_API_URL##|$QOTD_API_URL|g" ./usr/share/nginx/html/index.html
nginx -g "daemon off;"