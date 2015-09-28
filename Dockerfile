FROM debian:jessie
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES imagemagick inkscape
RUN apt-get update -y && apt-get install -y --no-install-recommends ${PACKAGES}
