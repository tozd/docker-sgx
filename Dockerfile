FROM tozd/runit:ubuntu-xenial

COPY ./patches /patches

RUN apt-get update -q -q && \
 apt-get install wget python git patch build-essential ocaml automake autoconf libtool libssl-dev libcurl4-openssl-dev protobuf-compiler protobuf-c-compiler libprotobuf-dev libprotobuf-c0-dev alien uuid-dev libxml2-dev cmake pkg-config --yes --force-yes && \
 mkdir -p /tmp/icls && \
 cd /tmp/icls && \
 wget http://registrationcenter-download.intel.com/akdlm/irc_nas/11414/iclsClient-1.45.449.12-1.x86_64.rpm && \
 alien --scripts iclsClient-1.45.449.12-1.x86_64.rpm && \
 dpkg -i iclsclient_1.45.449.12-2_amd64.deb && \
 rm -rf /tmp/icls && \
 cd /tmp && \
 git clone https://github.com/01org/dynamic-application-loader-host-interface.git && \
 cd /tmp/dynamic-application-loader-host-interface && \
 cmake . && \
 make && \
 make install && \
 rm -rf /tmp/dynamic-application-loader-host-interface && \
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
 /tmp/linux-sgx/linux/installer/bin/sgx_linux_x64_psw_*.bin && \
 rm -rf /tmp/linux-sgx

COPY ./etc /etc
