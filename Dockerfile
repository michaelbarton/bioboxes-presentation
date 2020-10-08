FROM debian:jessie
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES imagemagick inkscape
RUN apt-get update -y && apt-get install -y --no-install-recommends ${PACKAGES}

ADD fonts /fonts

RUN apt-get install --yes unzip
RUN mkdir -p /usr/share/fonts/googlefonts
RUN cd /usr/share/fonts/googlefonts && \
    unzip -d . /fonts/open_sans.zip && \
    fc-cache -fv && \
    fc-match OpenSans
