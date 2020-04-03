FROM python:3.6-stretch

# runtime dependencies
RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
	&& rm -rf /var/lib/apt/lists/*

ENV PGADMIN4_VERSION 4.20
ENV PGADMIN4_DOWNLOAD_URL https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl

# Metadata
LABEL org.label-schema.name="pgAdmin4" \
      org.label-schema.version="$PGADMIN4_VERSION" \
      org.label-schema.license="PostgreSQL" \
      org.label-schema.url="https://www.pgadmin.org" \
      org.label-schema.vcs-url="https://github.com/elesdoar/dockercloud-pgAdmin4"

RUN set -ex \
	&& buildDeps=" \
		gcc \
		libssl-dev \
		make" \
	&& apt-get update \
	&& apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& pip --no-cache-dir install $PGADMIN4_DOWNLOAD_URL \
	&& apt-get purge -y --auto-remove $buildDeps

VOLUME /var/lib/pgadmin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5050
CMD ["pgadmin4"]
