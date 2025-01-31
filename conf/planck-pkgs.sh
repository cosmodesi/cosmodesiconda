BASEDIR=$COSMODESICOSMO/common/planck
rm -rf $BASEDIR
mkdir -p $BASEDIR
rm $CONDADIR/lib/libattr*

TARBALL=COM_Likelihood_Code-v3.0_R3.10.tar.gz
curl "http://pla.esac.esa.int/pla/aio/product-action?COSMOLOGY.FILE_ID=$TARBALL" -o $TARBALL
#wget -O $TARBALL "http://pla.esac.esa.int/pla/aio/product-action?COSMOLOGY.FILE_ID=$TARBALL"
tar -xvzf $TARBALL -C $BASEDIR
CLIKDIR=$BASEDIR/code/plc_3.0/plc-3.1
export C_INCLUDE_PATH=$(python -c "from sysconfig import get_path as gp; print(gp(\"include\"))"):$C_INCLUDE_PATH
(cd $CLIKDIR; CFLAGS="" FCFLAGS="" ./waf configure --cfitsio_prefix=$CONDADIR --lapack_prefix=$CONDADIR; ./waf install)
rm $TARBALL

TARBALL=COM_Likelihood_Data-baseline_R3.00.tar.gz
curl "http://pla.esac.esa.int/pla/aio/product-action?COSMOLOGY.FILE_ID=$TARBALL" -o $TARBALL
#wget -O $TARBALL "http://pla.esac.esa.int/pla/aio/product-action?COSMOLOGY.FILE_ID=$TARBALL"
tar -xvzf $TARBALL -C $BASEDIR
rm $TARBALL

export PLANCK_SRC_DIR=$BASEDIR
export ENVVARIABLES="$ENVVARIABLES PLANCK_SRC_DIR $PLANCK_SRC_DIR"

if [ -f "$CLIKDIR/bin/clik_profile.sh" ]; then
    source $CLIKDIR/bin/clik_profile.sh
    export EXPORTPATH="$EXPORTPATH ${PATH%%:*}"
    export EXPORTPYTHONPATH="$EXPORTPYTHONPATH ${PYTHONPATH%%:*}"
    export EXPORTLDLIBRARYPATH="$EXPORTLDLIBRARYPATH $CONDADIR/lib $CLIKDIR/lib"
    export ENVVARIABLES="$ENVVARIABLES CLIK_PATH $CLIK_PATH CLIK_DATA $CLIK_DATA CLIK_PLUGIN $CLIK_PLUGIN"
fi