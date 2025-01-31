# class_public, for cobaya
# Unfortunately "make" does not build a standalone Python package: e.g. BBN files are still referenced in CLASS' main folder.
# So copy the full CLASS folder to the environment
mkdir -p $COSMODESICOSMO/common
BASEDIR=$COSMODESICOSMO/common
CLASS_VERSION=3.2.1
export CLASS_STD_DIR=$BASEDIR/class_public-$CLASS_VERSION
rm -rf $CLASS_STD_DIR

TARBALL=class-v$CLASS_VERSION.tar.gz
UNPACK=tmp-class-v$CLASS_VERSION
curl -fsSL https://github.com/lesgourg/class_public/archive/refs/tags/v$CLASS_VERSION.tar.gz > $TARBALL
#wget -O $TARBALL https://github.com/lesgourg/class_public/archive/refs/tags/v$CLASS_VERSION.tar.gz
mkdir -p $UNPACK
gzip -dc $TARBALL | tar xf - -C $UNPACK
mv $UNPACK/class_public-$CLASS_VERSION $CLASS_STD_DIR
(cd $CLASS_STD_DIR; make)
rm -rf $TARBALL
rm -rf $UNPACK

export ENVVARIABLES="$ENVVARIABLES CLASS_STD_DIR $CLASS_STD_DIR"
