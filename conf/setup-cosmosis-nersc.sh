# Load other modules
module load gsl/2.7
if [ "${NERSC_HOST}" == "cori" ] ; then
    GSLDIR=$GSL_DIR
elif [ "${NERSC_HOST}" == "perlmutter" ] ; then
    GSLDIR=$GSL_ROOT
    module load cpu
fi
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
export FFTW_INCLUDE_DIR=$CONDADIR/include
export FFTW_LIBRARY=$CONDADIR/lib
export CFITSIO_INC=$CONDADIR/include
export CFITSIO_LIB=$CONDADIR/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CFITSIO_LIB}:${COSMOSIS_SRC_DIR}/datablock
export COSMOSIS_OMP=1
# Because wrong order when specifying GSL_LIB path in cosmosis-standard-library/structure/EuclidEmumator2/setup.py 
export LIBRARY_PATH=$LIBRARY_PATH:${GSL_LIB}

if [ "${NERSC_HOST}" == "perlmutter" ] ; then
    # Tries to prevent cosmosis from launching any subprocesses, since that is not allowed on Perlmutter.
    export COSMOSIS_NO_SUBPROCESS=1
fi