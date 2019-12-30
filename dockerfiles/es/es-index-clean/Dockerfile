FROM 192.168.10.238/base/base_image:1.0
MAINTAINER yangdong <yangdong@chalco-steering.com>
COPY clean.sh /home/uimp/clean.sh
COPY es_index_clean_config /home/uimp/es_index_clean_config
RUN chmod +x /home/uimp/clean.sh
WORKDIR /home/uimp
ENTRYPOINT /home/uimp/clean.sh
