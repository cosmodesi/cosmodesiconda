#import jax
# Global flag to set a specific platform, must be used at startup
#jax.config.update('jax_platform_name', 'cpu')

from desilike import setup_logging
from desilike.install import Installer

setup_logging()
installer = Installer()

from desilike.likelihoods.supernovae import PantheonSNLikelihood
installer(PantheonSNLikelihood())
            
from desilike.likelihoods.cmb import TTTEEEHighlPlanck2018PlikLiteLikelihood
installer(TTTEEEHighlPlanck2018PlikLiteLikelihood())

from desilike.likelihoods.cmb import FullGridPlanck2018GaussianLikelihood
installer(FullGridPlanck2018GaussianLikelihood())