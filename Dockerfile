FROM alpine:3.5

MAINTAINER nVentiveUX

LABEL authors="Yves ANDOLFATTO, Vincent BESANCON"
LABEL license="MIT"
LABEL description="Docker image for Jupyter Notebook installation."

RUN set -x \
  && apk add --no-cache python3 ca-certificates build-base \
  && apk add --no-cache --virtual .builddeps python3-dev libpng-dev freetype-dev \
  && ln -s /usr/include/locale.h /usr/include/xlocale.h \
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir jupyter==1.0.0 \
  && pip3 install --no-cache-dir widgetsnbextension \
  && apk del .builddeps;

COPY ./docker-entrypoint.sh /

RUN addgroup -S -g 500 jupyter \
  && adduser -S -u 500 -D -G jupyter jupyter \
  && chmod +x /docker-entrypoint.sh \
  && chown jupyter:jupyter /docker-entrypoint.sh;

VOLUME ["/notebooks"]

USER jupyter

EXPOSE 8888
WORKDIR /notebooks

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["notebook", "--no-browser", "--ip=0.0.0.0"]
