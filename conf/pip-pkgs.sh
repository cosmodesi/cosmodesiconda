# Install pip packages.
echo Installing pip packages at $(date)

# see https://docs.nersc.gov/development/languages/python/parallel-python/
pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
MPICC=$MPICCPFFT pip install --no-cache-dir --no-binary=:all: git+https://github.com/adematti/pmesh
# install healpy with pip, as sometimes conda yields WARNING: version mismatch between CFITSIO header (as it reinstalls cfitsio)
pip install --no-cache-dir --no-deps healpy camb emcee dynesty zeus-mcmc pocomc schwimmbad dill corner getdist iminuit Py-BOBYQA bigfile
CC="cc" CFLAGS="" pip install --no-binary=:all: --no-cache-dir git+https://github.com/adematti/PolyChordLite@mpi4py
pip install --no-cache-dir 'blosc>=1.9.2' # for some reason, ImportError when conda install
pip install --no-cache-dir jax[cpu]


if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
