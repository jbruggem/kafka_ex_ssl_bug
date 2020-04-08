# Taken from
# https://github.com/c0b/docker-elixir/blob/0d9f47458468a8bf1407374731cbec077ab6f895/1.9/slim/Dockerfile

FROM erlang:21.2-slim

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.4" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="f3465d8a8e386f3e74831bf9594ee39e6dfde6aa430fe9260844cfe46aa10139" \
	&& buildDeps=' \
		ca-certificates \
		curl \
		make \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/*

################### Custom stuff added for this particular project
RUN apt-get update && \
		apt-get install -y --no-install-recommends git gcc && \
		rm -rf /var/lib/apt/lists/* && \
		mix local.hex --force && \
    mix local.rebar --force
