# Install pip packages.
echo Installing pip packages at $(date)

PYTHON=$(which python)
$PYTHON -m pip install 'ipywidgets==7.6.5'
# see https://docs.nersc.gov/development/languages/python/parallel-python/
$PYTHON -m pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/pfft-python
MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/pmesh
# install healpy with pip, as sometimes conda yields WARNING: version mismatch between CFITSIO header (as it reinstalls cfitsio)
$PYTHON -m pip install --no-cache-dir --no-deps healpy camb emcee dynesty zeus-mcmc pocomc schwimmbad dill corner getdist iminuit Py-BOBYQA bigfile hankl chainconsumer
# for abacusutils
$PYTHON -m pip install --no-cache-dir 'blosc>=1.9.2' # for some reason, ImportError when conda install
$PYTHON -m pip install parallel_numpy_rng
# for desilike
$PYTHON -m pip install torch
$PYTHON -m pip install --no-cache-dir jax[cpu]
$PYTHON -m pip install SciencePlots

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
