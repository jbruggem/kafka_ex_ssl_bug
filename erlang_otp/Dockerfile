FROM debian:stretch
# Source: https://github.com/erlang/docker-erlang-otp/blob/82a6a9dced87b9f70e7244193fa28892f5aae7d0/21/Dockerfile

ENV OTP_VERSION="21.3.8.1"

LABEL org.opencontainers.image.version=$OTP_VERSION

ARG fetchDeps='curl ca-certificates'
ARG runtimeDeps='libodbc1 libssl1.1 libsctp1'
ARG buildDeps='autoconf dpkg-dev gcc g++ make libncurses-dev unixodbc-dev libssl-dev libsctp-dev'

# We'll install the build dependencies, and purge them on the last step to make
# sure our final image contains only what we've just built:
RUN set -xe \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $fetchDeps  $runtimeDeps  $buildDeps \
  && rm -rf /var/lib/apt/lists/*

ARG OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz"
ARG OTP_DOWNLOAD_SHA256="2aac8e6e16eae2cf7ebee19b07ea7b5931a85763c4ff20186dd37125177f737f"

RUN curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz

ADD ingela_anderton_andin_p1.patch /p1.patch

RUN set -xe \
  && ( cd /usr/src/otp_src_* \
  && patch -p1 < /p1.patch \
  && ./otp_build autoconf \
  && gnuArch="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
  && ./configure --build="$gnuArch" \
  && make -j$(nproc) \
  && make install )

	# && find /usr/local -name examples | xargs rm -rf \
	# && rm -rf /usr/src/otp_src_*

RUN apt-get purge -y --auto-remove $buildDeps $fetchDeps

CMD ["erl"]
