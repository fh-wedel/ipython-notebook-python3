# Dockerfile for ipython-notebook based on python 3
#
# https://github.com/fh-wedel/docker-ipython-notebook-python3
#
# docker pull fhwedel/ipython-notebook-python3
#

# Using the Ubuntu image
FROM ubuntu:14.04

MAINTAINER Ulrich Hoffmann <uh@fh-wedel.de>

# Make sure apt is up to date
RUN apt-get -qq update && apt-get -qq upgrade

# Not essential, but wise to set the lang
RUN apt-get -qq install language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Python binary dependencies, developer tools
RUN apt-get -qq install build-essential make gcc zlib1g-dev git python3 python3-dev python3-pip
RUN apt-get -qq install libzmq3-dev sqlite3 libsqlite3-dev pandoc libcurl4-openssl-dev nodejs

# Upgrade pip3 itself
RUN pip3 install --upgrade pip

# ipython notebook
RUN pip3 install ipython[notebook]

# NumPy
RUN pip3 install numpy

# SciPy
RUN apt-get -qq install libatlas-base-dev gfortran
RUN pip3 install scipy

# Matplotlib
RUN apt-get -qq install libjpeg8-dev libfreetype6-dev libpng12-dev
RUN pip3 install matplotlib

# more package
RUN pip3 install sympy 
RUN pip3 install simpy 
RUN pip3 install pandas 
RUN pip3 install patsy 
RUN pip3 install scikit-learn 
RUN pip3 install distribute 
RUN pip3 install python-dateutil

WORKDIR /tmp
# RUN pip3 install statsmodels # does note compile on Python 3 as of 2014-09-03
RUN pip3 install cython
RUN git clone https://github.com/statsmodels/statsmodels
RUN cd statsmodels && pip3 install .
RUN rm -rf /tmp/statsmodels

RUN pip3 install ggplot  # depends on statsmodel

# RUN pip3 install dexy    # does not compile on Python 3 as of 2014-09-03
RUN pip3 install watchdog
RUN pip3 install pygments
RUN pip3 install oct2py

# pybrain
WORKDIR /tmp
# RUN git clone git://github.com/pybrain/pybrain.git # does not compile on Python 3 as of 2014-09-03
RUN git clone https://github.com/fh-wedel/pybrain.git
RUN cd pybrain && python3 setup.py install
RUN rm -rf /tmp/pybrain

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

# You can mount your own SSL certs as necessary here
ENV PEM_FILE /key.pem
ENV PASSWORD Dont make this your default

ADD notebook.sh /
RUN chmod u+x /notebook.sh
CMD /notebook.sh

# Again make sure apt is up to date (for security updating the image)
RUN apt-get -qq update && apt-get -qq upgrade

# docker run -d -p 8888:8888 -v $(HOME)/notebooks:/notebooks -e "PASSWORD=ipython" fhwedel/ipython-notebook-python3
