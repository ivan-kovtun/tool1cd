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

    # Keep the container running
    CMD ["tail", "-f", "/dev/null"]

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
COPY template.zip /root/template.zip
COPY actual_data.zip /root/actual_data.zip
# COPY deb_8_3_15_1656.tar.gz /root/deb_8_3_15_1656.tar.gz
COPY deb64_8_3_18_1959.tar.gz /root/deb64_8_3_18_1959.tar.gz
COPY client_8_3_18_1959.deb64.tar.gz /root/client_8_3_18_1959.deb64.tar.gz

# # Unzip the downloaded files
RUN unzip /root/template.zip -d /root/template \
    && unzip /root/actual_data.zip -d /root/actual_data

# Add execute permissions to files in tool-1cd/bin
# RUN chmod +x /root/tool-1cd/bin/*

# RUN mkdir /root/deb64_8_3_18_1959 \
#      && tar -xvf /root/deb64_8_3_18_1959.tar.gz -C /root/deb64_8_3_18_1959 \
#      && tar -xvf /root/client_8_3_18_1959.tar.gz -C /root/deb64_8_3_18_1959

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


RUN mkdir build && cd build


# Install 1C:Enterprise
# RUN dpkg -i /root/deb64_8_3_18_1959/*.deb || apt-get install -f -y

# # List files in /opt/1C/v8.3 recursively
# RUN ls -R /opt/1C/v8.3

