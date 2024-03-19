# FROM ubuntu as builder

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

# ENTRYPOINT ["python", "-m", "http.server", "8080"]
# # ENTRYPOINT ["python", "-V"]
# EXPOSE 8080

FROM nginx:alpine
COPY ./html /usr/share/nginx/html