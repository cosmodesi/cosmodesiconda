script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $COSMODESIROOT ] ; then
    echo "Load a cosmodesiconda module first to get COSMODESIROOT"
    exit 0
fi

MODULEDIR=$COSMODESIROOT/$NERSC_HOST/cosmodesiconda/startup/modulefiles/cosmodesimodules
mkdir -p $MODULEDIR

cp $script_dir/versions/* $MODULEDIR
cp $script_dir/*.png $MODULEDIR

scripts="activate_cosmodesi_jupyter.sh activate_cosmodesi_jupyter.csh cosmodesi_environment.sh cosmodesi_environment.csh install_jupyter_kernel.sh"
for script in $scripts ; do
    cp $script_dir/$script.gen $MODULEDIR/$script
    sed -i 's@_ROOTDIR_@'"$COSMODESIROOT"'@g' $MODULEDIR/$script
    ln -sf $MODULEDIR/$script $COSMODESIROOT/$script
done

chgrp -R desi $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR