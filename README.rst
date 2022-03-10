==============
cosmodesiconda
==============

Introduction
------------

This package, forked from desihub/desiconda and desihub/desimodules,
contains scripts for installing conda and all compiled
dependencies needed by the cosmological pipeline.


End-user: loading the current (main) environment (cosmodesiconda + cosmodesimodules)
------------------------------------------------------------------------------------

To setup environment::

    source /global/common/software/desi/users/adematti/cosmodesi_environment.sh main

To add environment as juyter kernel::
    
    ${COSMODESIMODULES}/install_jupyter_kernel.sh main


cosmodesiconda
--------------

Quick start installation 
~~~~~~~~~~~~~~~~~~~~~~~~

To install cosmodesiconda and load module::

    # set target 
    prefix=/global/common/software/desi/users/$USER
    mkdir -p $prefix 

    local_copy=/global/cfs/cdirs/desi/users/$USER
    git clone https://github.com/cosmodesi/cosmodesiconda $local_copy
    cd $local_copy

    unset PYTHONPATH
    export DCONDAVERSION=$(date '+%Y%m%d')-1.0.0
    PREFIX=$prefix ./install.sh |& tee install.log
    module use $prefix/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles
    module load cosmodesiconda
    
Example
~~~~~~~

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

    $> DCONDAVERSION=my-desiconda PREFIX=$HOME/software/desi CONF=myenv PKGS=mypkgs /path-to-git-clone/desiconda2/install.sh 2>&1 | tee log

If everything worked, then you can see your new desiconda install with::

    $> module use $HOME/software/desi/cosmodesiconda/$DCONDAVERSION/modulefiles
    $> module avail cosmodesiconda

And you can load it with::

    $> module load cosmodesiconda/$DCONDAVERSION

Configuration
~~~~~~~~~~~~~

If environment and pacakge files (conf/[envtag]-env.sh and conf/[pkgtag]-pkgs.sh) for
your use case already exists in the "conf" directory, then
just use them.  Otherwise, create or edit files in the "conf" subdirectory that 
are named after the environment and set of packages you wish to create and install.
See existing files conf/default-env.sh and conf/default-pkgs.sh for spectroscopic
pipeline dependencies on cori. 

Contents of installation
~~~~~~~~~~~~~~~~~~~~~~~~

The installation directory (assuming the installation script was called with 
$DCONDAVERSION and $PREFIX) will contain directories and files::

    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/conda
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/aux
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles/cosmodesiconda/$DCONDAVERSION
    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles/cosmodesiconda/.version_$DCONDAVERSION


cosmodesimodules
----------------

To install a suite of pyrecon, pycorr, etc. packages::

    ./cosmodesimodules/install.sh
 
Contents of installation
~~~~~~~~~~~~~~~~~~~~~~~~
Packages are installed in::

    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/code