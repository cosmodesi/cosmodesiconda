PYTHON=$(which python)
$PYTHON -m pip install cosmosis
export COSMOSIS_SRC_DIR=$(python -c "import os, cosmosis; print(os.path.dirname(cosmosis.__file__))")
mkdir -p $COSMODESICOSMO/cosmosis
export COSMOSIS_STD_DIR=$COSMODESICOSMO/cosmosis/cosmosis-standard-library
#rm $COSMODESICONDA/lib/libattr*

CONFIDR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $CONFDIR/setup-cosmosis-nersc.sh

rm -rf $COSMOSIS_STD_DIR
git clone --branch main https://github.com/joezuntz/cosmosis-standard-library $COSMOSIS_STD_DIR
(cd $COSMOSIS_STD_DIR; make; cp $CONFDIR/setup-cosmosis-nersc.sh .)
# For cosmodesiconda.gen
export ENVVARIABLES="$ENVVARIABLES COSMOSIS_SRC_DIR $COSMOSIS_SRC_DIR COSMOSIS_STD_DIR $COSMOSIS_STD_DIR"
export EXPORTLDLIBRARYPATH="$EXPORTLDLIBRARYPATH ${CFITSIO_LIB} ${COSMOSIS_SRC_DIR}/datablock"
