# Install pip packages.
echo Installing pip packages at $(date)

PYTHON=$(which python)
$PYTHON -m pip install 'scipy==1.12.0'
$PYTHON -m pip install 'ipywidgets==8.0.4'
# see https://docs.nersc.gov/development/languages/python/parallel-python/
# also https://docs.nersc.gov/development/languages/python/using-python-perlmutter/
MPICC=$MPICC $PYTHON -m pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/MP-Gadget/pfft-python
$PYTHON -m pip install --no-cache-dir git+https://github.com/MP-Gadget/pmesh
$PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/getdist
# install healpy with pip, as sometimes conda yields WARNING: version mismatch between CFITSIO header (as it reinstalls cfitsio)
$PYTHON -m pip install --no-cache-dir --no-deps healpy camb isitgr emcee dynesty zeus-mcmc schwimmbad dill corner iminuit Py-BOBYQA bigfile hankl chainconsumer pydantic  # pydantic for chainconsumer
$PYTHON -m pip install --no-cache-dir --no-deps git+https://github.com/minaskar/pocomc.git
# for abacusutils
$PYTHON -m pip install --no-cache-dir 'blosc>=1.9.2' # for some reason, ImportError when conda install
$PYTHON -m pip install parallel_numpy_rng
# ML
$PYTHON -m pip install torch==2.0.1+cu117 torchvision==0.15.2+cu117 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu117
$PYTHON -m pip install "tensorflow==2.11.0"
$PYTHON -m pip install "flax==0.8.2"
$PYTHON -m pip install "chex==0.1.86"
$PYTHON -m pip install "optax==0.2.2"
$PYTHON -m pip install "equinox==0.11.4"
$PYTHON -m pip install --no-deps interpax jaxtyping blackjax fastprogress typeguard
$PYTHON -m pip install SciencePlots
$PYTHON -m pip freeze | grep "nvidia*cu11" | xargs pip uninstall -y
$PYTHON -m pip freeze | grep "jaxlib" | xargs pip uninstall -y
$PYTHON -m pip install -U "jax[cuda11_pip]==0.4.25" --find-links=https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
$PYTHON -m pip install "nvidia-cudnn-cu11==8.9.4.25"

# Just for docs
$PYTHON -m pip install sphinx sphinx-rtd-theme

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
