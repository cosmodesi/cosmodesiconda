# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=desi
export PRGENVS="PrgEnv-gnu PrgEnv-intel PrgEnv-cray PrgEnv-nvidia"
export CONDAPRGENV=PrgEnv-gnu
export MPILOGIN=T
# darshan not necessary and suspected to generate overhead
# altd not necessary and suspected to cause random job hangs
# craype-hugepages2M https://docs.nersc.gov/development/languages/python/faq-troubleshooting
export UNLOADMODULES="darshan altd craype-hugepages2M"
export LOADMODULES="gsl texlive/2019"
export HOSTVARIABLE=NERSC_HOST

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

# needed for mpi4py
if [ "${NERSC_HOST}" == "cori" ] ; then
  # see https://docs.nersc.gov/development/languages/python/parallel-python/
  export MPICC="cc -shared"
elif [ "${NERSC_HOST}" == "perlmutter" ] ; then
  # see https://docs.nersc.gov/development/languages/python/using-python-perlmutter
  export LOADMODULES=${LOADMODULES} cudatoolkit
  export MPICC="cc -target-accel=nvidia80 -shared"
fi
export MPICCPFFT="cc"
