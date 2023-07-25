# Cobaya stuffs
pip install cobaya
export COBAYA_STD_DIR=$COSMODIR/cobaya
rm -rf $COBAYA_STD_DIR
export COBAYA_PACKAGES_PATH=$COBAYA_STD_DIR

mkdir $COBAYA_PACKAGES_PATH/code/planck


cobaya-install bicep_keck_2018 sn.pantheon bao.sdss_dr12_consensus_final bao.sixdf_2011_bao bao.sdss_dr7_mgs bao.sdss_dr16_baoplus_lrg bao.sdss_dr16_baoplus_elg bao.sdss_dr16_baoplus_qso bao.sdss_dr16_baoplus_lyauto bao.sdss_dr16_baoplus_lyxqso des_y1.joint planck_2018_highl_plik.TTTEEE planck_2018_lowl.TT planck_2018_lowl.EE -p $COBAYA_STD_DIR
pip install --no-cache-dir git+https://github.com/HTJense/pyWMAP
cobaya-install wmaplike.WMAPLike
wget https://raw.githubusercontent.com/HTJense/pyWMAP/main/eval_wmap.yaml .
cobaya-run eval_wmap.yaml  # to install sz_spectra
rm eval_wmap.yaml
rm -rf chains
pip install --no-cache-dir git+https://github.com/ACTCollaboration/pyactlike
pip install git+https://github.com/xgarrido/spt_likelihoods.git
cobaya-install spt3g_2020.TEEE
#wget https://raw.githubusercontent.com/xgarrido/spt_likelihoods/master/examples/spt3g_example.yaml .
#cobaya-run spt3g_example.yaml
#pip install --no-cache-dir git+https://github.com/ACTCollaboration/act_dr6_lenslike
#wget https://lambda.gsfc.nasa.gov/data/suborbital/ACT/ACT_dr6/likelihood/data/ACT_dr6_likelihood_v1.1.tgz
export ENVVARIABLES="$ENVVARIABLES COBAYA_STD_DIR $COBAYA_STD_DIR COBAYA_PACKAGES_PATH $COBAYA_PACKAGES_PATH COBAYA_USE_FILE_LOCKING F"
rm -rf $COBAYA_PACKAGES_PATH/code/planck/clik-main
ln -s $PLANCK_SRC_DIR/code/plc_3.0/plc-3.1 $COBAYA_PACKAGES_PATH/code/planck/clik-main  # installed by planck-pkgs.sh