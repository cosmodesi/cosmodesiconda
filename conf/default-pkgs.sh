CONFIDR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $CONFDIR/conda-pkgs.sh
source $CONFDIR/pip-pkgs.sh
for sc in $COSMOINSTALL ; do
    if [[ ! -z $sc ]] ; then
        source $CONFDIR/$sc
    fi
done
if [[ ! -z ${MPILOGIN} ]] ; then
    source $CONFDIR/mpilogin-pkgs.sh  # outdated: MPI install for NERSC cori login nodes
fi