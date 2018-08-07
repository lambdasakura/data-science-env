FROM nvidia/cuda:9.0-cudnn7-devel

ARG user=user
ARG group=user
ARG uid=1000
ARG gid=1000

ENV LC_ALL=C.UTF-8
ENV LANG=ja_JP.UTF-8

ENV USER_HOME /var/user_home
VOLUME /var/user_home

# to use repository at japan 
RUN sed -i -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get upgrade -y \
    # add repository for python
    && apt-get install --no-install-recommends -y software-properties-common curl \
    # for Node.js
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && add-apt-repository ppa:jonathonf/python-3.6 \
    && apt-get update && apt-get install --no-install-recommends -y \
           git \
           build-essential \
           imagemagick \
           make \
           curl \
           xz-utils \
           file \
           sudo \
           fonts-ipaexfont \
           fonts-ipaexfont-gothic \
           fonts-ipaexfont-mincho \
           fonts-ipafont \
           fonts-ipafont-gothic \
           fonts-ipafont-mincho \
           fonts-ipamj-mincho \
           language-pack-ja-base \
           language-pack-ja \
           ruby \
           ruby2.3-dev \
           software-properties-common  \
           mecab \
           libmecab-dev \
           mecab-ipadic-utf8 \
           python3.6 \
           python3.6-dev \
           pandoc \
           texlive-xetex \
           latex-beamer \
           texlive-luatex \
           texlive-lang-cjk \
           lmodern \
           texlive-xetex \
           nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mecab dic 
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y && \
    cd .. && \
    rm -rf mecab-ipadic-neologd
 
# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        awscli \
        flake8 \
        python-dotenv \
        flask \
        pipenv \
        click \
        Sphinx \
        coverage \
        numpy \
        pandas \
        matplotlib \
        scipy \
        seaborn \
        scikit-learn \
        scikit-image \
        sympy \
        cython \
        patsy \
        cloudpickle \
        dill \
        numba \
        bokeh \
        gensim \
        gitpython \
        tqdm \
        tensorflow-gpu \
        h5py \
        opencv-python \
        opencv-contrib-python \
        scrapy \
        scrapy-splash \
        jupyter \
        jupyter_contrib_nbextensions \
        jupyterlab && \
    jupyter contrib nbextension install && \
    jupyter serverextension enable --py jupyterlab

# for Data analytics
RUN git clone https://github.com/statsmodels/statsmodels && \
    cd statsmodels && \
    pip --no-cache-dir install . && \
    cd .. && \
    rm -rf statmodels

# for Japanese Input
RUN locale-gen ja_JP.UTF-8

# setup jupyter 
COPY article.tplx /usr/local/lib/python3.6/dist-packages/nbconvert/templates/latex/
COPY jupyter_notebook_config.py /usr/local/etc/jupyter/

# add user 
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$USER_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}

# start jupyter notebook
CMD jupyter lab

## Install for wp2txt 
#RUN sudo gem install wp2txt
