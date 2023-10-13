PYTHON=$(which python)
$PYTHON -m pip install cosmosis
export COSMOSIS_SRC_DIR=$(python -c "import os, cosmosis; print(os.path.dirname(cosmosis.__file__))")
mkdir -p $COSMODIR/cosmosis
export COSMOSIS_STD_DIR=$COSMODIR/cosmosis/cosmosis-standard-library
#rm $CONDADIR/lib/libattr*

source $CONFDIR/setup-cosmosis-nersc.sh

rm -rf $COSMOSIS_STD_DIR
git clone --branch main https://github.com/joezuntz/cosmosis-standard-library $COSMOSIS_STD_DIR
(cd $COSMOSIS_STD_DIR; make; cp $CONFDIR/setup-cosmosis-nersc.sh .)
# For cosmodesiconda.gen
export ENVVARIABLES="$ENVVARIABLES COSMOSIS_SRC_DIR $COSMOSIS_SRC_DIR COSMOSIS_STD_DIR $COSMOSIS_STD_DIR"
export EXPORTLDLIBRARYPATH="$EXPORTLDLIBRARYPATH ${CFITSIO_LIB} ${COSMOSIS_SRC_DIR}/datablock"
