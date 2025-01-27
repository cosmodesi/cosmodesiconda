# Install pip packages.
echo Installing pip packages at $(date)

PYTHON=$(which python)
$PYTHON -m pip install 'ipywidgets==8.0.4'
# see https://docs.nersc.gov/development/languages/python/parallel-python/
# also https://docs.nersc.gov/development/languages/python/using-python-perlmutter/
CC=$MPICC $PYTHON -m pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
$PYTHON -m pip install --no-cache-dir git+https://github.com/MP-Gadget/pmesh
$PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/getdist
# install healpy with pip, as sometimes conda yields WARNING: version mismatch between CFITSIO header (as it reinstalls cfitsio)
$PYTHON -m pip install --no-cache-dir --no-deps healpy camb isitgr emcee dynesty zeus-mcmc schwimmbad dill corner iminuit Py-BOBYQA bigfile hankl chainconsumer pydantic  # pydantic for chainconsumer
$PYTHON -m pip install --no-cache-dir --no-deps git+https://github.com/minaskar/pocomc.git
# for abacusutils
$PYTHON -m pip install --no-cache-dir 'blosc>=1.9.2' # for some reason, ImportError when conda install
$PYTHON -m pip install parallel_numpy_rng
# ML
#pip install torch==2.1.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
#$PYTHON -m pip install tensorflow==2.15.0
#$PYTHON -m pip install --upgrade "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
$PYTHON -m pip install tensorflow
$PYTHON -m pip install "jax[cuda12]"
$PYTHON -m pip install torch
$PYTHON -m pip install flax
$PYTHON -m pip install --no-deps interpax equinox jaxtyping blackjax fastprogress jaxopt typeguard


#$PYTHON -m pip install torch==2.0.1+cu117 torchvision==0.15.2+cu117 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu117
#$PYTHON -m pip install "tensorflow==2.11.0"
#$PYTHON -m pip install "jax[cuda11_cudnn82]==0.4.7" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html  # this will update cuda libraries installed by torch, but torch does not seem to complain
#$PYTHON -m pip install "orbax-checkpoint=0.4.7"
#$PYTHON -m pip install "flax==0.7.2"
#$PYTHON -m pip install "chex==v0.1.7"  # higher versions required
$PYTHON -m pip install optax
$PYTHON -m pip install SciencePlots
$PYTHON -m pip install numpyro
$PYTHON -m pip install "diffrax==0.5.0"
# Just for docs
$PYTHON -m pip install sphinx sphinx-rtd-theme

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
