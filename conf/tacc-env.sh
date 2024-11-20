# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=desi
export PRGENVS="PrgEnv-gnu PrgEnv-intel PrgEnv-cray PrgEnv-nvidia"
export CONDAPRGENV=PrgEnv-gnu
export COSMOINSTALL="classy-pkgs.sh planck-pkgs.sh nersc-cosmosis-pkgs.sh cobaya-pkgs.sh desilike-pkgs.sh desipipe-pkgs.sh nersc-scripts.sh"
#export COSMOINSTALL="planck-pkgs.sh"
# darshan not necessary and suspected to generate overhead
# altd not necessary and suspe  cted to cause random job hangs
# craype-hugepages2M https://docs.nersc.gov/development/languages/python/faq-troubleshooting
export UNLOADMODULES=""
#export LOADMODULES="cudatoolkit cudnn/8.9.1_cuda11 nccl/2.17.1-ofi cray-hdf5"
#export LOADMODULES="cudatoolkit/12.2 cudnn/8.9.3_cuda12 nccl/2.17.1-ofi cray-hdf5"
export LOADMODULES="intel hdf5 gsl mvapich2-gdr-cuda12 petsc/3.19-cuda cuda/12.2"
export HOSTVARIABLE=NERSC_HOST

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

export ENVVARIABLES="HDF5_USE_FILE_LOCKING FALSE"
export MPICCPFFT="cc"
export ENVVARIABLES="${ENVVARIABLES} TF_CPP_MIN_LOG_LEVEL 2"
export ENVVARIABLES_LOGIN="JAX_PLATFORMS cpu"
export ENVVARIABLES_NODES="JAX_PLATFORMS """
