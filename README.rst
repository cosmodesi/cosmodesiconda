===========
desiconda
===========

Introduction
---------------

This package contains scripts for installing conda and all compiled
dependencies needed by the spectroscopic pipeline.  The rules to install
or build each dependency is separated into a file, and used by both
regular installs and building docker images.


Configuration
----------------

For normal installs, create or edit a file in the "conf_normal" directory.
This file defines compiler options, install prefix, version string, etc for
all the dependencies.  See existing files for examples.

Also edit a corresponding file in the "conf_normal_init" directory that
contains a module file snippet


Installation
------------

You can install these tools in a variety of ways.  Here are several that may be of interest:

1.  Manually running from the git checkout.  Add the "bin" directory to your $PATH environment variable and add the "py" directory to your $PYTHONPATH environment variable.
2.  Install (and uninstall) a symlink to your live git checkout::

        $>  python setup.py develop --prefix=/path/to/somewhere
        $>  python setup.py develop --prefix=/path/to/somewhere --uninstall

3.  Install a fixed version of the tools::

        $>  python setup.py install --prefix=/path/to/somewhere


Versioning
----------

If you have tagged a version and wish to set the package version based on your current git location::

    $>  python setup.py version

And then install as usual.

Full Documentation
------------------

Please visit `desispec on Read the Docs`_

.. image:: https://readthedocs.org/projects/desispec/badge/?version=latest
    :target: http://desispec.readthedocs.org/en/latest/
    :alt: Documentation Status

.. _`desispec on Read the Docs`: http://desispec.readthedocs.org/en/latest/

Travis Build Status
-------------------

.. image:: https://img.shields.io/travis/desihub/desispec.svg
    :target: https://travis-ci.org/desihub/desispec
    :alt: Travis Build Status


Test Coverage Status
--------------------

.. image:: https://coveralls.io/repos/desihub/desispec/badge.svg?service=github
    :target: https://coveralls.io/github/desihub/desispec
    :alt: Test Coverage Status

License
-------

desispec is free software licensed under a 3-clause BSD-style license. For details see
the ``LICENSE.rst`` file.