FROM python:3-alpine

WORKDIR /app
COPY requirements.txt requirements.txt
COPY premiumizer .
RUN apk update
RUN apk add --update --no-cache libffi-dev openssl-dev build-base su-exec shadow aria2 rclone bash

RUN pip install --no-cache-dir -r requirements.txt

RUN addgroup -S -g 6006 premiumizer
RUN adduser -S -D -u 6006 -G premiumizer -s /bin/sh premiumizer

VOLUME /conf
EXPOSE 5000
RUN aria2c -D --on-download-complete=/config/rclone.conf --disable-ipv6=true --enable-rpc --rpc-allow-origin-all --rpc-listen-all --rpc-listen-port=6800 --rpc-secret=premiumizer --max-connection-per-server=16 --file-allocation=none --disk-cache=0
ENTRYPOINT ["/bin/sh","docker-entrypoint.sh"]
CMD ["/usr/local/bin/python", "premiumizer.py"] & bash aria.sh

