# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge
export MINICONDA=https://github.com/conda-forge/miniforge/releases/download/24.5.0-0/Miniforge3-$(uname)-$(uname -m).sh
#export MINICONDA=https://github.com/conda-forge/miniforge/releases/download/24.1.2-0/Miniforge3-$(uname)-$(uname -m).sh
export GRP=
export COSMOINSTALL="classy-pkgs.sh planck-pkgs.sh cobaya-pkgs.sh desilike-pkgs.sh desipipe-pkgs.sh"
#export COSMOINSTALL="planck-pkgs.sh"
# darshan not necessary and suspected to generate overhead
# altd not necessary and suspected to cause random job hangs
# craype-hugepages2M https://docs.nersc.gov/development/languages/python/faq-troubleshooting
export HOSTVARIABLE=

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=4

export MPICC="mpicc"
export MPICCPFFT="mpicc"
export ENVVARIABLES="${ENVVARIABLES} TF_CPP_MIN_LOG_LEVEL 2"
export ENVVARIABLES_LOGIN="JAX_PLATFORMS """
export ENVVARIABLES_NODES="JAX_PLATFORMS """
