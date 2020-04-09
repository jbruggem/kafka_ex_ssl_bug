# Taken from
# https://github.com/c0b/docker-elixir/blob/0d9f47458468a8bf1407374731cbec077ab6f895/1.9/slim/Dockerfile
ARG OTP_VERSION
FROM erlang:${OTP_VERSION}-slim

ARG ELIXIR_VERSION
ENV LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& buildDeps=' \
		ca-certificates \
		curl \
		make \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/*

################### Custom stuff added for this particular project
RUN apt-get update && \
		apt-get install -y --no-install-recommends git build-essential ca-certificates && \
		rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && \
    mix local.rebar --force
