script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $CONF ] ; then CONF=nersc;   fi
source $script_dir/../conf/$CONF-env.sh

if [ -z $COSMODESIROOT ] ; then
    echo "Load a cosmodesiconda module first to get COSMODESIROOT"
    exit 0
fi

COSMODESIROOTHOST=$COSMODESIROOT
COSMODESIROOTHOSTENV=$COSMODESIROOT
if [ ! -z $HOSTVARIABLE ] ; then
    COSMODESIROOTHOST=$COSMODESIROOT/${!$HOSTVARIABLE}
    COSMODESIROOTHOSTENV=$COSMODESIROOT'/$env('$HOSTVARIABLE')'
fi

MODULEDIR=$COSMODESIROOTHOST/cosmodesiconda/startup/modulefiles/cosmodesimodules
mkdir -p $MODULEDIR

cp $script_dir/*.png $MODULEDIR

for script in $script_dir/versions/* ; do
    filename=$(basename -- "$script")
    filename="${filename%.*}"
    cp $script_dir/versions/$filename.gen $MODULEDIR/$filename
    sed -i 's@_ROOTDIR_@'"$COSMODESIROOTHOST"'@g' $MODULEDIR/$filename
done

scripts="activate_cosmodesi_jupyter.sh activate_cosmodesi_jupyter.csh cosmodesi_environment.sh cosmodesi_environment.csh install_jupyter_kernel.sh"
for script in $scripts ; do
    cp $script_dir/$script.gen $MODULEDIR/$script
    sed -i 's@_ROOTDIR_@'"$COSMODESIROOT"'@g' $MODULEDIR/$script
    ln -sf $MODULEDIR/$script $COSMODESIROOT/$script
done

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR