==============
cosmodesiconda
==============

Introduction
------------

This package, forked from desihub/desiconda and desihub/desimodules,
contains scripts for installing conda and all compiled
dependencies needed by the cosmological pipeline.


NERSC end-user: loading the current (main) environment (cosmodesiconda + cosmodesimodules)
------------------------------------------------------------------------------------------

To setup environment::

    source /global/common/software/desi/users/adematti/cosmodesi_environment.sh main

To add environment as juyter kernel::
    
    ${COSMODESIMODULES}/install_jupyter_kernel.sh main


cosmodesiconda at NERSC
-----------------------

conda
~~~~~

To install cosmodesiconda and load module::

    git clone https://github.com/cosmodesi/cosmodesiconda
    cd cosmodesiconda

    export CONF=nersc
    export DCONDAVERSION=$(date '+%Y%m%d')-1.0.0
    PREFIX=/global/common/software/desi/users/$USER COSMOPREFIX=/global/cfs/cdirs/desi/science/cpe/$USER ./install.sh |& tee install.log
    module use $prefix/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles
    module load cosmodesiconda

The installation directory (assuming the installation script was called with 
$DCONDAVERSION and $PREFIX) will contain directories and files::

    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/conda
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/aux
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles/cosmodesiconda/$DCONDAVERSION
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles/cosmodesiconda/.version_$DCONDAVERSION


cosmodesimodules
~~~~~~~~~~~~~~~~

To install a suite of pyrecon, pycorr, etc. packages::

    cd cosmodesimodules
    ./install.sh

Packages are installed in::

    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/code


cosmodesiconda on your cluster
------------------------------
    
conda
~~~~~

Imagine you wanted to install a set of dependencies for DESI software on a
cluster (rather than manually getting all the dependencies in place).  
You plan on installing desiconda in your home directory ($HOME/software/desi)
and you want to have the custom string "my-desiconda" associated with your
installation.

You git-cloned cosmodesiconda using::

    git clone https://github.com/cosmodesi/cosmodesiconda /path-to-git-clone/cosmodesiconda

You also put all the commands for dependencies you want to install and
customizations in the "conf/mypkgs-pkgs.sh" and "conf/myenv-env.sh" files
you created (based on the existing
conf/default-pkgs.sh and conf/nersc-env.sh), respectively.

This install.sh script, in the top-level directory, will create the environment
and install the dependencies and module files. When you run this script, it
will download many MB of binary and source packages, extract files, and compile things.  It will do this in your current working directory.
Also the output will be very long, so pipe it to a log file::

    $> export CONF=myenv
    $> DCONDAVERSION=my-desiconda PREFIX=$HOME/software/desi PKGS=mypkgs /path-to-git-clone/desiconda2/install.sh 2>&1 | tee log

If everything worked, then you can see your new desiconda install with::

    $> module use $HOME/software/desi/cosmodesiconda/$DCONDAVERSION/modulefiles
    $> module avail cosmodesiconda

And you can load it with::

    $> module load cosmodesiconda/$DCONDAVERSION

cosmodesimodules
~~~~~~~~~~~~~~~~

To install a suite of pyrecon, pycorr, etc. packages::

    ./cosmodesimodules/install.sh


TD;DR: after logging in to TACC, run::
    cdw; git clone -b TACC https://github.com/cosmodesi/cosmodesiconda.git ; cd cosmodesiconda ; export CONF=tacc ; DCONDAVERSION=my-desiconda PREFIX=$WORK/software/desi/ PKGS=default $WORK/cosmodesiconda/install.sh 2>&1 | tee log ; cd $WORK/software/desi/cosmo/cosmodesiconda/my-desiconda/cobaya/code/PolyChordLite ; make clean ; make COMPILER_TYPE=gnu ; pip install . --user ; cd $WORK