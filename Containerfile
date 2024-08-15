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
FROM nginx:1.21-alpine
# copy static files to nginx server root
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY container_run.sh .

# start Nginx in the foreground when the container is run
RUN chmod +x ./container_run.sh
RUN chmod 777 ./
RUN chown -R 1001:0 /usr/share/nginx/html
RUN chown -R 1001:0 /var/cache/nginx && chmod -R ug+rwx /var/cache/nginx && chown -R 1001:0 /var/run
RUN chown -R 1001:0 /run

USER 1001

EXPOSE 8080

CMD ./container_run.sh


# FROM docker.io/nginx
# WORKDIR /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY *.* .

# RUN chmod +x ./container_run.sh
# RUN chmod 777 ./
# RUN chown -R 1001:0 /var/cache/nginx && chmod -R ug+rwx /var/cache/nginx && chown -R 1001:0 /var/run
# RUN chown -R 1001:0 /run

# USER 1001

# EXPOSE 8080

# CMD ./container_run.sh