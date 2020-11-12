# LFPy showcase

This Lab contains various demonstrations on how LFPy (https://github.com/LFPy/LFPy, https://LFPy.rtfd.io) can be utilized on HPC infrastructure via Unicore: https://wiki.ebrains.eu/bin/view/Collabs/hybridlfpy-showcase


# Docker

[![Docker](https://img.shields.io/badge/Docker-yes-green.svg)](https://hub.docker.com/r/lfpy/hybridlfpy)

## hybridLFPy Docker recipe

We provide a Docker (https://www.docker.com) container build file with hybridLFPy and dependencies.
To get started, install Docker and issue either:

    $ docker pull lfpy/hybridlfpy
    $ docker run -it -p 5000:5000 lfpy/hybridlfpy

or

    $ docker build -t hybridlfpy Dockerfile
    $ docker run -it -p 5000:5000 hybridlfpy

The ``--mount`` option can be used to mount a folder on the host to a target folder as:

    $ docker run --mount type=bind,source="$(pwd)",target=/opt/<folder> -it -p 5000:5000 lfpy/hybridlfpy

which mounts the present working dirctory (``$(pwd)``) to the ``/opt/<folder>`` directory of the container.
Try mounting the ``hybridLFPy`` source directory (``git clone https://github.com/INM-6/hybridLFPy.git``) for example (by setting ``source="<path-to-hybridLFPy>"``). Various hybridLFPy example files can then be found in the folder ``/opt/hybridLFPy/examples/``
when the container is running.

Jupyter notebook servers running from within the
container can be accessed after invoking them by issuing:

    $ cd /opt/hybridLFPy/examples/
    $ jupyter notebook --ip 0.0.0.0 --port=5000 --no-browser --allow-root

and opening the resulting URL in a browser on the host computer, similar to:
http://127.0.0.1:5000/?token=dcf8f859f859740fc858c568bdd5b015e0cf15bfc2c5b0c1

## Docker recipes for Singularity/HPC computing

The container recipe(s) may be suitable for high-performance computing (HPC) facilities,
using the ``MPICH`` library using the `hybrid` model of
Singularity (https://sylabs.io/guides/3.6/user-guide/index.html),
see https://sylabs.io/guides/3.6/user-guide/mpi.html#hybrid-model for details.

How to configure the build may depend on tools available on the compute cluster.
For one example, see https://gitlab.version.fz-juelich.de/bvonstvieth_publications/container_userdoc_tmp.

After building, hybridLFPy python code can be executed in parallel as

    $ <mpi-executable> singularity exec <container-file> python3 -u <myscript.py>

or

    $ singularity exec <container-file> mpirun python3 -u <myscript.py>
