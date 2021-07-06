conda install --copy --yes \
    nose \
    requests \
    future \
    cython \
    cmake \
    numpy \
    scipy \
    mkl=2020.0 \
    matplotlib \
    seaborn \
    pyyaml \
    astropy \
    pytest-astropy \
    hdf5 \
    h5py \
    psutil \
    ephem \
    psycopg2 \
    pytest \
    pytest-cov \
    numba \
    sqlalchemy \
    scikit-learn \
    scikit-image \
    ipython \
    jupyter \
    ipywidgets \
    bokeh \
    wurlitzer \
    certipy \
    sphinx \
    iminuit \
    cudatoolkit \
&& conda install --copy --yes -c conda-forge \
    fitsio \
    galsim \
    dask \
    distributed \
    papermill \
&& mplrc="@CONDA_PREFIX@/lib/python@PYVERSION@/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
&& rm -rf @CONDA_PREFIX@/pkgs/*
