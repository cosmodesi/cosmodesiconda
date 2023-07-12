# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

conda install --copy --yes -c conda-forge \
    future \
    'numpy>=1.16' \
    'scipy>=1.5.0' \
    matplotlib \
    cfitsio \
    fitsio \
    h5py \
    cython \
    'pyfftw=0.12' \
    sympy \
    numexpr \
    'astropy>=4.0.0' \
    scikit-learn \
    ipython \
    jupyterlab \
    ipywidgets \
    wurlitzer \
    'numba>=0.56' \
    'asdf>=2.13' \
    pandas \
    dask \
    pytest \
    scikit-learn \
    tabulate \
&& mplrc="$CONDADIR/lib/python$PYVERSION/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
&& conda clean --yes --all

if [ $? != 0 ]; then
    echo "ERROR installing conda packages; exiting"
    exit 1
fi

conda list --export | grep -v conda > "$CONDADIR/pkg_list.txt"
echo Current time $(date) Done installing conda packages