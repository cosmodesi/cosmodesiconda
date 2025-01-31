# Compilers
export COSMOSIS_ALT_COMPILERS=1
export CC=gcc
export CXX=g++
export FC=gfortran
export MPIFC=ftn
export MPIF90=ftn

# Environment variables for compilation
export LAPACK_LINK="-L$CRAY_LIBSCI_PREFIX_DIR/lib -lsci_gnu"
export GSL_INC=$GSLDIR/include
export GSL_LIB=$GSLDIR/lib
export FFTW_INCLUDE_DIR=$COSMODESICONDA/include
export FFTW_LIBRARY=$COSMODESICONDA/lib
export CFITSIO_INC=$COSMODESICONDA/include
export CFITSIO_LIB=$COSMODESICONDA/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CFITSIO_LIB}:${COSMOSIS_SRC_DIR}/datablock
export COSMOSIS_OMP=1
# Because wrong order when specifying GSL_LIB path in cosmosis-standard-library/structure/EuclidEmumator2/setup.py
export LIBRARY_PATH=$LIBRARY_PATH:${GSL_LIB}

# Setup that needs the conda path
if [[ "${NERSC_HOST}" == "perlmutter" ]]
then
    # Tries to prevent cosmosis from launching any subprocesses, since that is not allowed
    # on Perlmutter.
    export COSMOSIS_NO_SUBPROCESS=1

    # Fixes missing support in the Perlmutter libfabric:
    # https://docs.nersc.gov/development/languages/python/using-python-perlmutter/#missing-support-for-matched-proberecv
    export MPI4PY_RC_RECV_MPROBE=0
    module load evp-patch

else
    echo Unknown NERSC host
    return
fi