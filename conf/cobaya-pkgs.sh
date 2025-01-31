# Cobaya stuffs

PYTHON=$(which python)
$PYTHON -m pip install git+https://github.com/CobayaSampler/cobaya
export COBAYA_STD_DIR=$COSMODIR/cobaya
rm -rf $COBAYA_STD_DIR
export COBAYA_PACKAGES_PATH=$COBAYA_STD_DIR

mkdir -p $COBAYA_PACKAGES_PATH/code/planck

cobaya-install bicep_keck_2018 sn.pantheon bao.sdss_dr12_consensus_final bao.sixdf_2011_bao bao.sdss_dr7_mgs bao.sdss_dr16_baoplus_lrg bao.sdss_dr16_baoplus_elg bao.sdss_dr16_baoplus_qso bao.sdss_dr16_baoplus_lyauto bao.sdss_dr16_baoplus_lyxqso des_y1.joint planck_2018_highl_plik.TTTEEE planck_2018_lowl.TT planck_2018_lowl.EE planck_2018_highl_CamSpec2021.TTTEEE planck_NPIPE_highl_CamSpec.TEEE planck_NPIPE_highl_CamSpec.TTTEEE planck_2018_highl_plik.TT_lite_native -p $COBAYA_STD_DIR
$PYTHON -m pip install git+https://github.com/carronj/planck_PR4_lensing
$PYTHON -m pip install --no-cache-dir git+https://github.com/HTJense/pyWMAP
cobaya-install wmaplike.WMAPLike
wget https://raw.githubusercontent.com/HTJense/pyWMAP/main/eval_wmap.yaml .
cobaya-run eval_wmap.yaml  # to install sz_spectra
rm eval_wmap.yaml
rm -rf chains
$PYTHON -m pip install planck-2020-hillipop planck-2020-lollipop
$PYTHON -m pip install git+https://github.com/ACTCollaboration/pyactlike
$PYTHON -m pip install git+https://github.com/xgarrido/spt_likelihoods.git
cobaya-install spt3g_2020.TEEE spt3g_2022.TTTEEE

#git clone https://github.com/planck-npipe/hillipop.git
#cobaya-install hillipop/examples/hillipop_example.yaml
#rm -rf hillipop

git clone https://github.com/PolyChord/PolyChordLite.git
(cd PolyChordLite && $PYTHON -m python setup.py install)
rm -rf PolyChordLite
#wget https://raw.githubusercontent.com/xgarrido/spt_likelihoods/master/examples/spt3g_example.yaml .
#cobaya-run spt3g_example.yaml
version='1.2'
$PYTHON -m pip install --no-cache-dir act_dr6_lenslike==$version
#$PYTHON -m pip install --no-cache-dir git+https://github.com/ACTCollaboration/act_dr6_lenslike
ACT_DIR=$COBAYA_PACKAGES_PATH/data/act_dr6_lenslike/
mkdir -p $ACT_DIR
wget -O $ACT_DIR/tmp-act.tgz https://lambda.gsfc.nasa.gov/data/suborbital/ACT/ACT_dr6/likelihood/data/ACT_dr6_likelihood_v$version.tgz
tar -C $ACT_DIR -xvzf $ACT_DIR/tmp-act.tgz
rm -rf $ACT_DIR/tmp-act.tgz
ACT_SYMLINK=$(python -c "import os, act_dr6_lenslike; print(os.path.dirname(act_dr6_lenslike.__file__))")/data
mkdir -p $ACT_SYMLINK
ln -s $ACT_DIR/v$version $ACT_SYMLINK/v$version
export ENVVARIABLES="$ENVVARIABLES COBAYA_STD_DIR $COBAYA_STD_DIR COBAYA_PACKAGES_PATH $COBAYA_PACKAGES_PATH COBAYA_USE_FILE_LOCKING F"
rm -rf $COBAYA_PACKAGES_PATH/code/planck/clik-main
ln -s $PLANCK_SRC_DIR/code/plc_3.0/plc-3.1 $COBAYA_PACKAGES_PATH/code/planck/clik-main  # installed by planck-pkgs.sh
