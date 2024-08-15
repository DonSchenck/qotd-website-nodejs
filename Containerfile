FROM node:lts AS base
WORKDIR /app
COPY . .
# install all dependencies
RUN npm install
# ---- Build ----
FROM base AS build
WORKDIR /app
RUN npm run build

# ---- Release ----
FROM registry.access.redhat.com/ubi9/nginx-124:1-20
# copy static files to nginx server root
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY container_run.sh .

# start Nginx in the foreground when the container is run
USER root
RUN chmod 777 ./container_run.sh
RUN chmod 777 ./
RUN chmod 777 /usr/share/nginx/html

EXPOSE 8080

CMD ./container_run.sh