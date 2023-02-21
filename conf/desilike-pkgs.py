from desilike.likelihoods.supernovae import PantheonSNLikelihood
from desilike.install import Installer
installer = Installer()
installer(PantheonSNLikelihood())
            
from desilike.likelihoods.cmb import TTTEEEHighlPlanck2018PlikLiteLikelihood
from desilike.install import Installer
installer = Installer()
installer(TTTEEEHighlPlanck2018PlikLiteLikelihood())