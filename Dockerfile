# =============================================================================
# cetres/centos-android-ionic
#
# CentOS-7, Android, Ionic 2
#
# =============================================================================
FROM centos:centos7
MAINTAINER Gustavo Oliveira <cetres@gmail.com>

# -----------------------------------------------------------------------------
# Environments variables and parameters
# -----------------------------------------------------------------------------
ENV JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm" \
    ANDROID_HOME="/opt/android_sdk" \
    ANDROID_URL="https://dl.google.com/android/repository/tools_r25.2.3-linux.zip" \
    ANDROID_BUILD_TOOLS="25.0.2" \
    ANDROID_PLATFORMS="android-25"

ENV PATH $PATH:$ANDROID_HOME/tools

# -----------------------------------------------------------------------------
# Import the RPM GPG keys for Repositories
# -----------------------------------------------------------------------------
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# -----------------------------------------------------------------------------
# Install dependencies
# -----------------------------------------------------------------------------
RUN yum update -y && \ 
    yum install -y unzip \
                   nodejs \
    yum clean all

# -----------------------------------------------------------------------------
# Install Oracle Java
# http://www.oracle.com/technetwork/java/javase/downloads/
# -----------------------------------------------------------------------------
RUN curl -s -j -L -H "Cookie: oraclelicense=accept-securebackup-cookie" ${JDK_URL} -o /tmp/jdk.rpm && \
    rpm -ih /tmp/jdk.rpm && \
    rm /tmp/jdk.rpm

# -----------------------------------------------------------------------------
# Install Google Android Tools
# https://developer.android.com/studio/
# -----------------------------------------------------------------------------
RUN curl -s ${ANDROID_URL} -o /tmp/android_tools.zip && \
    unzip /tmp/android_tools.zip -d ${ANDROID_HOME} && \
    rm /tmp/android_tools.zip && \
    echo y |/opt/android_sdk/tools/android update sdk -a -u -t platform-tools,${ANDROID_PLATFORMS},build-tools-${ANDROID_BUILD_TOOLS}

# -----------------------------------------------------------------------------
# Install Apache Cordova
# https://cordova.apache.org/
# -----------------------------------------------------------------------------
npm install -g cordova

# -----------------------------------------------------------------------------
# Install Ionic
# https://ionicframework.com/docs/v2/setup/installation/
# -----------------------------------------------------------------------------
npm install -g ionic

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
yum clean all

