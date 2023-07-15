# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=desi
export PRGENVS="PrgEnv-gnu PrgEnv-intel PrgEnv-cray PrgEnv-nvidia"
export CONDAPRGENV=PrgEnv-gnu
export MPILOGIN=T
export COSMODIR=/global/cfs/cdirs/desi/science/cpe/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION
mkdir -p $COSMODIR
export COSMOINSTALL="classy-pkgs.sh planck-pkgs.sh nersc-cosmosis-pkgs.sh cobaya-pkgs.sh desilike-pkgs.sh"
#export COSMOINSTALL="planck-pkgs.sh"
# darshan not necessary and suspected to generate overhead
# altd not necessary and suspected to cause random job hangs
# craype-hugepages2M https://docs.nersc.gov/development/languages/python/faq-troubleshooting
export UNLOADMODULES="darshan altd craype-hugepages2M"
export LOADMODULES="gsl cray-hdf5"
export HOSTVARIABLE=NERSC_HOST

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

# needed for mpi4py
if [ "${NERSC_HOST}" == "cori" ] ; then
  # See https://docs.nersc.gov/development/languages/python/parallel-python/
  export LOADMODULES="${LOADMODULES} texlive/2019"
  export ENVVARIABLES="HDF5_USE_FILE_LOCKING FALSE"
  export MPICC="cc -shared"
elif [ "${NERSC_HOST}" == "perlmutter" ] ; then
  # See https://docs.nersc.gov/development/languages/python/using-python-perlmutter
  export MPILOGIN=""
  export LOADMODULES="e4s/22.05 ${LOADMODULES} cudatoolkit texlive"
  export ENVVARIABLES="MPI4PY_RC_RECV_MPROBE FALSE CXI_FORK_SAFE 1 CXI_FORK_SAFE_HP 1"
  #export MPICC="cc -target-accel=nvidia80 -shared"
  export MPICC="cc -shared"
fi
export ENVVARIABLES="${ENVVARIABLES} DESI_ROOT /global/cfs/cdirs/desi"
export MPICCPFFT="cc"

