FROM ubuntu:22.04

RUN apt-get update && apt-get install curl wget systemd containerd -y && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://get.docker.com/ | sh;

RUN useradd builder
RUN usermod -aG docker builder

ENV BUILD_DIR=/home/builder/tcb

RUN mkdir -p ${BUILD_DIR}

WORKDIR ${BUILD_DIR}

#Setup script
RUN wget https://raw.githubusercontent.com/toradex/tcb-env-setup/master/tcb-env-setup.sh
#Run script with the bash built-in command 'source'. 
RUN /bin/bash -c 'source tcb-env-setup.sh -a remote'
RUN chown -R builder ${BUILD_DIR}   

USER builder

#Keep the container runnning even if run non-interactively
CMD ["sleep", "infinity"]