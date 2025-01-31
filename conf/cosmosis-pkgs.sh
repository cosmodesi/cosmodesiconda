PYTHON=$(which python)
conda install gsl lapack
$PYTHON -m pip install cosmosis
export COSMOSIS_SRC_DIR=$(python -c "import os, cosmosis; print(os.path.dirname(cosmosis.__file__))")
mkdir -p $COSMODESICOSMO/cosmosis
export COSMOSIS_STD_DIR=$COSMODESICOSMO/cosmosis/cosmosis-standard-library
#rm $COSMODESICONDA/lib/libattr*

# Compilers
export COSMOSIS_ALT_COMPILERS=1
export CC=gcc
export CXX=g++
export FC=gfortran
export MPIFC=ftn
export MPIF90=ftn

# Environment variables for compilation
export LAPACK_LINK="-L$COSMODESICONDA/lib"
export GSL_INC=$COSMODESICONDA/include
export GSL_LIB=$COSMODESICONDA/lib
export FFTW_INCLUDE_DIR=$COSMODESICONDA/include
export FFTW_LIBRARY=$COSMODESICONDA/lib
export CFITSIO_INC=$COSMODESICONDA/include
export CFITSIO_LIB=$COSMODESICONDA/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CFITSIO_LIB}:${COSMOSIS_SRC_DIR}/datablock
export COSMOSIS_OMP=1
# Because wrong order when specifying GSL_LIB path in cosmosis-standard-library/structure/EuclidEmumator2/setup.py
export LIBRARY_PATH=$LIBRARY_PATH:${GSL_LIB}


rm -rf $COSMOSIS_STD_DIR
git clone --branch main https://github.com/joezuntz/cosmosis-standard-library $COSMOSIS_STD_DIR
(cd $COSMOSIS_STD_DIR; make)
# For cosmodesiconda.gen
export ENVVARIABLES="$ENVVARIABLES COSMOSIS_SRC_DIR $COSMOSIS_SRC_DIR COSMOSIS_STD_DIR $COSMOSIS_STD_DIR"
export EXPORTLDLIBRARYPATH="$EXPORTLDLIBRARYPATH ${CFITSIO_LIB} ${COSMOSIS_SRC_DIR}/datablock"
