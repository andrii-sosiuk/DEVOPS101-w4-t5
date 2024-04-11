#  FROM ubuntu as builder

# WORKDIR /src
# RUN apt-get update&&apt-get install git nasm build-essential curl -y
# # RUN git clone https://github.com/jcalvinowens/asmhttpd.git && cd asmhttpd && make
# RUN git clone https://github.com/den-vasyliev/asmhttpd.git&&cd asmhttpd && make

# FROM scratch
# WORKDIR /html
# ADD ./html /html
# COPY --from=builder /src/asmhttpd/asmhttpd /
# ENTRYPOINT ["/asmhttpd", "/html"]
# # ENTRYPOINT ["/bin/bash"]
# EXPOSE 8080

# FROM python:3

# WORKDIR /html
# ADD ./html /html


FROM python:alpine

WORKDIR /app

RUN apk update && apk add --no-cache cairo
RUN pip install cairosvg pillow
COPY . /app/

# ENTRYPOINT ["python", "python/simple_http_server.html", "html", "8000"]
CMD ["python", "python/simple_http_server.py", "html", "8000"]
EXPOSE 8000

# FROM nginx:alpine
# COPY ./html /usr/share/nginx/html