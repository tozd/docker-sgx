FROM tozd/runit:ubuntu-trusty

COPY ./patches /patches

RUN apt-get update -q -q && \
 apt-get install wget python git patch build-essential ocaml automake autoconf libtool libcurl4-openssl-dev protobuf-compiler protobuf-c-compiler libprotobuf-dev libprotobuf-c0-dev --yes --force-yes && \
 cd /tmp && \
 git clone https://github.com/01org/linux-sgx.git && \
 cd / && \
 for patch in /patches/*; do patch --prefix=/patches/ -p0 --force "--input=$patch" || exit 1; done && \
 rm -rf /patches && \
 cd /tmp/linux-sgx && \
 ./download_prebuilt.sh && \
 make && \
 make sdk_install_pkg && \
 make psw_install_pkg && \
 mkdir -p /opt/intel && \
 cd /opt/intel && \
 yes yes | /tmp/linux-sgx/linux/installer/bin/sgx_linux_x64_sdk_*.bin && \
 /tmp/linux-sgx/linux/installer/bin/sgx_linux_x64_psw_*.bin

COPY ./etc /etc
