rootdir=$(realpath $COSMODESICONDA/../../../../)
basedir=$COSMODESICONDA/../../startup/modulefiles/cosmodesimodules
mkdir -p $basedir

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp $script_dir/* $basedir

ln -sf $basedir/activate_cosmodesi_jupyter.sh $rootdir/activate_cosmodesi_jupyter.sh
ln -sf $basedir/activate_cosmodesi_jupyter.csh $rootdir/activate_cosmodesi_jupyter.csh
ln -sf $basedir/cosmodesi_environment.sh $rootdir/cosmodesi_environment.sh
ln -sf $basedir/cosmodesi_environment.csh $rootdir/cosmodesi_environment.csh