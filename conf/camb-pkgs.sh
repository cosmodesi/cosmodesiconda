# camb, for cobaya
# With CosmoRec
mkdir -p $COSMODESICOSMO/common
BASEDIR=$COSMODESICOSMO/common

# CosmoRec
COSMOREC_VERSION=2.0.3b
export COSMOREC_STD_DIR=$BASEDIR/cosmorec-$COSMOREC_VERSION
TARBALL=cosmorec-$COSMOREC_VERSION.tar.gz
UNPACK=tmp-cosmorec-$COSMOREC_VERSION
curl -fsSL https://www.cita.utoronto.ca/~jchluba/Recombination/_Downloads_/CosmoRec.v$COSMOREC_VERSION.tar.gz > $TARBALL
mkdir -p $UNPACK
tar -xvf $TARBALL -C $UNPACK
mv $UNPACK/CosmoRec.v$COSMOREC_VERSION $COSMOREC_STD_DIR
sed -i 's/CXXFLAGS = -Wall -pedantic -O2/CXXFLAGS = -Wall -pedantic -O2 -fPIC/' $COSMOREC_STD_DIR/Makefile.in
(cd $COSMOREC_STD_DIR; make all)
rm -rf $TARBALL
rm -rf $UNPACK

# CAMB
CAMB_VERSION=1.5.4
export CAMB_STD_DIR=$BASEDIR/camb-$CAMB_VERSION
rm -rf $CAMB_STD_DIR
TARBALL=camb-$CAMB_VERSION.tar.gz
UNPACK=tmp-camb-$CAMB_VERSION
curl -fsSL https://github.com/cmbant/CAMB/archive/refs/tags/$CAMB_VERSION.tar.gz > $TARBALL
mkdir -p $UNPACK
gzip -dc $TARBALL | tar xf - -C $UNPACK
mv $UNPACK/CAMB-$CAMB_VERSION $CAMB_STD_DIR
(cd $CAMB_STD_DIR; RECOMBINATION_FILES="recfast cosmorec" COSMOREC_PATH=$COSMOREC_STD_DIR python setup.py make)
rm -rf $TARBALL
rm -rf $UNPACK

export ENVVARIABLES="$ENVVARIABLES COSMOREC_STD_DIR $CAMB_STD_DIR CAMB_STD_DIR $CAMB_STD_DIR"
export EXPORTPYTHONPATH="$EXPORTPYTHONPATH $CAMB_STD_DIR"