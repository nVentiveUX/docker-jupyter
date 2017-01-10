FROM alpine:3.5

MAINTAINER nVentiveUX

LABEL authors="Yves ANDOLFATTO, Vincent BESANCON"
LABEL license="MIT"
LABEL description="Docker image for Jupyter Notebook installation."

RUN set -x \
  && apk add --no-cache --update tini python3 ca-certificates build-base py-psutil \
  && apk add --no-cache --update --virtual .builddeps python3-dev libpng-dev freetype-dev \
  && ln -s /usr/include/locale.h /usr/include/xlocale.h \
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir jupyter==1.0.0 \
  && pip3 install --no-cache-dir jupyter-nbextensions-configurator==0.2.3 \
  && pip3 install --no-cache-dir jupyter-contrib-nbextensions==0.2.3 \
  && apk del .builddeps;

COPY ./docker-entrypoint.sh /

RUN addgroup -S -g 500 jupyter \
  && adduser -S -u 500 -D -G jupyter jupyter \
  && mkdir -p -m 700 /notebooks \
  && chown jupyter:jupyter /notebooks \
  && chmod +x /docker-entrypoint.sh \
  && chown jupyter:jupyter /docker-entrypoint.sh;

VOLUME ["/notebooks"]

RUN set -x \
  && jupyter contrib nbextension install --system \
  && jupyter nbextensions_configurator enable --system \
  && jupyter nbextension enable dragdrop/main --system \
  && jupyter nbextension enable hide_input/main --system \
  && jupyter nbextension enable navigation-hotkeys/main --system \
  && jupyter nbextension enable printview/main --system \
  && jupyter nbextension enable addbefore/main --system \
  && jupyter nbextension enable init_cell/main --system \
  && jupyter nbextension enable toc2/main --system \
  && jupyter nbextension enable execute_time/ExecuteTime --system \
  && jupyter nbextension enable rubberband/main --system \
  && jupyter nbextension enable scroll_down/main --system \
  && jupyter nbextension enable table_beautifier/main --system \
  && jupyter nbextension enable autoscroll/main --system \
  && jupyter nbextension enable datestamper/main --system \
  && jupyter nbextension enable help_panel/help_panel --system \
  && jupyter nbextension enable highlighter/highlighter --system \
  && jupyter nbextension enable move_selected_cells/main --system \
  && jupyter nbextension enable notify/notify --system \
  && jupyter nbextension enable ruler/main --system \
  && jupyter nbextension enable search-replace/main --system \
  && jupyter nbextension enable toggle_all_line_numbers/main --system \
  && jupyter nbextension enable contrib_nbextensions_help_item/main --system;

USER jupyter

# Add a notebook profile.
RUN mkdir -p -m 700 /home/jupyter/.jupyter/ \
  && echo "c.NotebookApp.ip = '*'" > ~/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

EXPOSE 8888
WORKDIR /notebooks

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["notebook"]
