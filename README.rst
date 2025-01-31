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

To add environment as jupyter kernel::

    ${COSMODESIMODULES}/install_jupyter_kernel.sh main


Tips
~~~~

If you would like to install a package "yourpackage" that is not originally in the cosmodesi environment, you can do so in your home following e.g.::

  pip install --user yourpackage

or if you have its repository locally, once in the main directory, in editable mode::

  pip install --editable .

If you would like to use the personal version of a package that is already installed as a module (listed by "module list") in the cosmodesi environment::

  module unload yourpackage

Then install the package in your home as shown above. Note that you will have to unload "yourpackage" everytime you source the environment,
so you would better add this function to your .bashrc::

  cosmodesienv () {
      source /global/common/software/desi/users/adematti/cosmodesi_environment.sh $1
      module unload yourpackage
  }

And call::

  cosmodesienv main

Alternatively to "module unload yourpackage" you can just add the path to the local package version at the beginning of your PYTHONPATH after sourcing the cosmodesi environment::

  cosmodesienv () {
    source /global/common/software/desi/users/adematti/cosmodesi_environment.sh $1
    export PYTHONPATH=/path/to/package:$PYTHONPATH
  }

(you may also need to similarly update PATH, if the installed package has scripts).
The above is also the path to follow if you would like to use the personal version of a package that is installed as a standard Python package in the cosmodesi environment.


cosmodesiconda at NERSC
-----------------------

conda
~~~~~

To install cosmodesiconda and load module::

    git clone https://github.com/cosmodesi/cosmodesiconda
    cd cosmodesiconda

    export CONF=nersc
    export DCONDAVERSION=$(date '+%Y%m%d')-1.0.0
    export PREFIX=/global/common/software/desi/users/$USER
    COSMOPREFIX=/global/cfs/cdirs/desi/science/cpe/$USER ./install.sh |& tee install.log
    module use $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/modulefiles
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
    ./install.sh main

Packages are installed in::

    $PREFIX/$NERSC_HOST/cosmodesiconda/$DCONDAVERSION/code

To install convenient loading scripts "cosmodesi_environment.sh" do::

    ./install_activate.sh

cosmodesiconda on your cluster
------------------------------

conda
~~~~~

Imagine you wanted to install a set of dependencies for DESI software on a
cluster (rather than manually getting all the dependencies in place).
You plan on installing desiconda in your home directory ($HOME/software/desi)
with the custom string "my-desiconda" associated with your installation.

Git-clone cosmodesiconda following::

    git clone https://github.com/cosmodesi/cosmodesiconda /path-to-git-clone/cosmodesiconda

Put all the customizations in the "conf/myenv-env.sh" file (based on the existing conf/nersc-env.sh).

The "install.sh" script, in the top-level directory, will create the environment
and install the dependencies and module files. When you run this script, it
will download many MB of binary and source packages, extract files, and compile things.
It will do this in your current working directory.
Also the output will be very long, so pipe it to a log file::

    cd /path-to-git-clone/cosmodesiconda
    export CONF=myenv
    export DCONDAVERSION=my-desiconda
    export PREFIX=$HOME/software/desi
    ./install.sh |& tee install.log

If everything worked, then you can see your new desiconda install with::

    module use $PREFIX/cosmodesiconda/$DCONDAVERSION/modulefiles
    module avail cosmodesiconda

And you can load it with::

    module load cosmodesiconda/$DCONDAVERSION

cosmodesimodules
~~~~~~~~~~~~~~~~

To install a suite of pyrecon, pycorr, etc. packages (and the corresponding module files)::

    cd cosmodesimodules
    ./install.sh main

Packages are installed in::

    $PREFIX/cosmodesiconda/$DCONDAVERSION/code

NB: You can edit the list of modules to be installed in "cosmodesimodules/pkg_list.txt" and create new environment versions (other than "main") in "cosmodesimodules/versions".
If some modules failed to install, and you do not need them, you can comment them out from the list in::

    $PREFIX/cosmodesiconda/startup/modulefiles/cosmodesimodules/main

To install convenient loading scripts "cosmodesi_environment.sh" and "install_jupyter_kernel.sh" do::

    ./install_activate.sh

Then, to setup environment::

    source $PREFIX/cosmodesi_environment.sh main

To add environment as jupyter kernel::

    ${COSMODESIMODULES}/install_jupyter_kernel.sh main


cosmodesiconda on your PC
-------------------------

The current recommended way is to install Modules, see: https://modules.readthedocs.io/en/latest/INSTALL.html#install.
And follow the section above "cosmodesiconda on your cluster".
You can use the configuration file "conf/pc-env.sh", i.e.::

    export CONF=pc


Updating some modules
---------------------

To update already-installed modules, in "cosmodesimodules", you can create a file like "pkg_list.txt"
containing the packages to be updated and call it "update_pkg_list.txt". Then run::

    ./update_pkgs.sh