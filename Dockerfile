FROM alpine:latest

LABEL maintainer="Mikhail Orlov <miklergm@gmail.com>"

RUN apk update \
  && apk add --virtual build-dependencies \
  build-base \
  gcc \
  sqlite-dev \
  zlib-dev \
  # git \
  && apk add \
  bash

RUN mkdir -p /src
WORKDIR /src

COPY . .

WORKDIR ./tippecanoe

# failed to make with LDFLAGS=-static 
RUN make \
  && PREFIX=/opt/tippecanoe make install

#### Stage 1
FROM alpine:latest

COPY --from=0 /opt/tippecanoe/bin/* /usr/bin/

RUN apk add --no-cache libgcc libstdc++ sqlite-libs

ENTRYPOINT /bin/sh