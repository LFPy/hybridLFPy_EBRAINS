FROM buildpack-deps:focal

RUN apt-get update && \
    apt-get install -y \
    cmake \
    libmpich-dev \
    mpich \
    doxygen \
    libboost-dev \
    libgsl-dev \
    cython3 \
    python3-dev \
    python3-pip

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

RUN pip install mpi4py

# Install NEST 3 (master branch @v3.0)
ARG WITH_MPI=ON
ARG WITH_OMP=ON
ARG WITH_GSL=ON
RUN wget https://github.com/nest/nest-simulator/archive/v3.0.tar.gz && \
  mkdir nest-build && \
  tar zxf v3.0.tar.gz && \
  mv nest-simulator-3.0 nest-simulator && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        -Dwith-boost=ON \
        -Dwith-ltdl=ON \
        -Dwith-gsl=$WITH_GSL \
        -Dwith-readline=ON \
        -Dwith-python=ON \
        -Dwith-mpi=$WITH_MPI \
        -Dwith-openmp=$WITH_OMP \
        ../nest-simulator && \
  make -j4 && \
  make install && \
  cd ..

# clean up install/build files
RUN rm v3.0.tar.gz
RUN rm -r nest-simulator
RUN rm -r nest-build


# ---- additional requirements
RUN apt-get install -y \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-pandas \
    ipython3 \
    jupyter

RUN update-alternatives --install /usr/bin/ipython ipython /usr/bin/ipython3 10

# installing serial h5py (deb package installs OpenMPI which may conflict with MPICH)
RUN pip install h5py


# ---- install neuron -----
RUN pip install neuron


# --- Install hybridLFPy ----
RUN pip install git+https://github.com/INM-6/hybridLFPy.git@master#egg=hybridLFPy


# ---- Install additional dependencies for examples ----
RUN pip3 install git+https://github.com/NeuralEnsemble/parameters@b95bac2bd17f03ce600541e435e270a1e1c5a478


# Add NEST binary folder to PATH
ENV PATH /opt/nest/bin:${PATH}

# Add pyNEST to PYTHONPATH
ENV PYTHONPATH /opt/nest/lib/python3.8/site-packages:${PYTHONPATH}

# If running with Singularity, run the below line in the host.
# PYTHONPATH set here doesn't carry over:
# export SINGULARITYENV_PYTHONPATH=/opt/nest/lib/python3.8/site-packages
# Alternatively, run "source /opt/local/bin/nest_vars.sh" while running the container
