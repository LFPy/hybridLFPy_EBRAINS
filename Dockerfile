FROM buildpack-deps:focal

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential libtool automake autotools-dev \
        libreadline8 libreadline-dev freeglut3-dev \
        gosu \
        cmake \
        cython3 \
        jq \
        libboost-dev \
        libgomp1 \
        libgsl-dev \
        libltdl7 \
        libltdl-dev \
        libmusic1v5 \
        libmpich-dev \
        libomp-dev \
        libpcre3 \
        libpcre3-dev \
        libpython3.8 \
        llvm-dev \
        mpich \
        pep8 \
        python3-dev \
        python3-ipython \
        python3-jupyter-core \
        python3-matplotlib \
        #python3-mpi4py \
        python3-nose \
        python3-numpy \
        python3-pandas \
        python3-path \
        python3-pip \
        python3-scipy \
        python3-setuptools \
        python3-statsmodels \
        python3-tk \
        python-dev \
        doxygen \
        vera++ \
        wget  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # update-alternatives --remove-all python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

RUN pip install --upgrade pip
RUN pip install mpi4py


# ----- Install NEST -----
RUN git clone https://github.com/nest/nest-simulator.git && \
  cd nest-simulator && \
  # git checkout master && \
  git checkout 24de43dc21c568e017839eeb335253c2bc2d487d && \
  cd .. && \
  mkdir nest-build && \
  ls -l && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        -Dwith-ltdl=ON \
	    -Dwith-gsl=ON \
	    -Dwith-readline=ON \
        -Dwith-python=ON \
        -Dwith-mpi=ON \
        -Dwith-openmp=ON \
        ../nest-simulator && \
  make -j4 && \
  make install
  cd ..


# clean up install/build files
#RUN rm 24de43dc21c568e017839eeb335253c2bc2d487d.tar.gz
#RUN rm -r nest*


# ---- install neuron -----
RUN pip install neuron


# ---- install LFPy@2.2.dev0 -----
RUN pip install git+https://github.com/LFPy/LFPy.git@2.2.dev0#egg=LFPy


# --- Install hybridLFPy ----
RUN pip install git+https://github.com/INM-6/hybridLFPy.git@nest3#egg=hybridLFPy


# ---- Install additional dependencies for examples ----
RUN pip3 install git+https://github.com/NeuralEnsemble/parameters@b95bac2bd17f03ce600541e435e270a1e1c5a478


# run this every time the container i started...
ENTRYPOINT [". /opt/nest/bin/nest_vars.sh"]
