# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=idphp
export PRGENVS="gnu9 intel"
export CONDAPRGENV=gnu9
export MPILOGIN=
export COSMOINSTALL="classy-pkgs.sh planck-pkgs.sh cobaya-pkgs.sh desilike-pkgs.sh desipipe-pkgs.sh"
export UNLOADMODULES=anaconda
export LOADMODULES="cports/rhel-8.x86_64 gsl openmpi hdf5"
export HOSTVARIABLE=

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

export MPICC="mpicc"
export MPICCPFFT="mpicc"
export ENVVARIABLES="${ENVVARIABLES} DESI_ROOT /drf/projets/desi"
