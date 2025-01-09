# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    pipx \
    unzip \
    cmake \
    make \
    g++ \
    libstdc++-14-dev 

# Ensure pipx binaries are in PATH
ENV PATH="/root/.local/bin:$PATH"

# Install AWS CLI using pip
RUN pipx install awscli

# Copy AWS credentials
COPY .aws /root/.aws

# Configure AWS CLI
RUN aws configure set default.region eu-central-1

# # # Download binaries from S3 bucket
# # RUN aws s3 cp s3://gw-tsd-binaries/ ~/ --recursive

# COPY linux.zip /root/linux.zip
RUN mkdir /root/tool-1cd 
COPY src/ /root/tool-1cd/src/
COPY CMakeLists.txt /root/tool-1cd/CMakeLists.txt
# COPY template.zip /root/template.zip
# COPY actual_data.zip /root/actual_data.zip
COPY platform /root/platform

# # Unzip the downloaded files
# RUN unzip /root/template.zip -d /root/template \
#     && unzip /root/actual_data.zip -d /root/actual_data

RUN mkdir /root/platform/8_3 \
    && for file in /root/platform/client*.tar.gz; do tar -xvf "$file" -C /root/platform/8_3; done \
    && for file in /root/platform/deb*.tar.gz; do tar -xvf "$file" -C /root/platform/8_3; done

# # Install libraries for tools1cd
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:mhier/libboost-latest -y
RUN apt update -y
RUN apt install -y \
    libboost-all-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-regex-dev \
    zlib1g-dev \
    libqt6core5compat6-dev

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN add-apt-repository 'deb [trusted=yes] http://cz.archive.ubuntu.com/ubuntu bionic main universe'
RUN apt-get update
RUN apt-get install -qq libwebkitgtk-1.0-0

# Install 1C:Enterprise
RUN dpkg -i /root/platform/8_3/1c-enterprise83-common*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-server*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-ws*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-client*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-common-nls*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-server-nls*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-ws-nls*.deb
RUN dpkg -i /root/platform/8_3/1c-enterprise83-client-nls*.deb
# RUN dpkg -i /root/platform/8_3/*.deb || apt-get install -f -y

RUN rm -rf /root/platform

WORKDIR /root/tool-1cd    
RUN mkdir build && cd build \
    && cmake .. \
    && make \
    && make install

RUN LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

ENV PATH="/opt/1C/v8.3/x86_64:$PATH"
CMD ["tail", "-f", "/dev/null"]


# Extract actual data
# RUN mkdir actual_tables
# RUN ctool1cd -l /root/ctool1cd_extract.log /root/actual_data/1Cv8.1CD -eb /root/actual_tables "*"

# Build updatated mobile data base
# RUN ctool1cd -l /root/ctool1cd_build.log /root/template/1Cv8.1CD -ib /root/actual_tables

# Install 1C:Enterprise
# RUN dpkg -i /root/deb64_8_3_18_1959/*.deb || apt-get install -f -y

# # List files in /opt/1C/v8.3 recursively
# RUN ls -R /opt/1C/v8.3

# ctool1cd -l /root/ctool1cd.log /root/template/1Cv8.1CD -sts /root/template_files.lst

