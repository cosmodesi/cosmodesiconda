import os
import numpy as np


def generate_catalogs(size=100, boxsize=(1000.,) * 3, boxcenter=(1000.,) * 3, n_individual_weights=1, n_bitwise_weights=0, seed=42):
    rng = np.random.RandomState(seed=seed)
    toret = []
    for i in range(2):
        positions = [c + rng.uniform(-0.5, 0.5, size) * s for c, s in zip(boxcenter, boxsize)]
        weights = [rng.randint(0, 0xffffffff, size, dtype='i8') for i in range(n_bitwise_weights)]
        weights += [rng.uniform(0.5, 1., size) for i in range(n_individual_weights)]
        toret.append(positions + weights)
    return toret


def test_cosmoprimo():

    # cosmoprimo, pyclass, camb
    from cosmoprimo.fiducial import DESI

    DESI(engine='class').get_fourier().pk_interpolator()
    DESI(engine='camb').get_fourier().pk_interpolator()


def test_pycorr():

    data, randoms = generate_catalogs()

    from pycorr import TwoPointCorrelationFunction
    TwoPointCorrelationFunction(mode='smu', edges=(np.linspace(0., 50., 51), np.linspace(-1., 1., 51)), data_positions1=data[:3],
                                randoms_positions1=randoms[:3], data_weights1=data[3:], randoms_weights1=randoms[3:], nthreads=1)
    TwoPointCorrelationFunction(mode='smu', edges=(np.linspace(0., 50., 51), np.linspace(-1., 1., 51)), data_positions1=data[:3],
                                randoms_positions1=randoms[:3], data_weights1=data[3:], randoms_weights1=randoms[3:], nthreads=1, gpu=True)


def test_pypower():

    from pypower import CatalogFFTPower
    data, randoms = generate_catalogs(size=10000)
    CatalogFFTPower(edges={'step': 0.01}, data_positions1=data[:3], randoms_positions1=randoms[:3], data_weights1=data[3:], randoms_weights1=randoms[3:], nmesh=64)


def test_pyrecon():

    data, randoms = generate_catalogs(size=10000)
    from pyrecon import MultiGridReconstruction
    data_positions, data_weights = np.column_stack(data[:3]), data[3]
    randoms_positions, randoms_weights = np.column_stack(randoms[:3]), randoms[3]
    recon = MultiGridReconstruction(f=0.8, bias=2.0, los=None, nmesh=32, boxsize=2000., boxcenter=1000.)
    recon.assign_data(data_positions, data_weights)
    recon.assign_randoms(randoms_positions, randoms_weights)
    recon.set_density_contrast()
    recon.run()
    data_positions_rec = recon.read_shifted_positions(data_positions)


def test_abacusutils():
    # abacusutils
    import abacusnbody.data.compaso_halo_catalog
    from abacusnbody.data import read_abacus
    fn = '/global/cfs/cdirs/desi/public/cosmosim/AbacusSummit/AbacusSummit_base_c000_ph000/halos/z0.800/halo_rv_A/halo_rv_A_000.asdf'
    read_abacus.read_asdf(fn, load=['pos'])['pos']


def test_mockfactory():
    # mockfactory
    from mockfactory import Catalog


def test_desilike():
    # desilike
    from desilike.theories.galaxy_clustering import EFTLikeKaiserTracerPowerSpectrumMultipoles, ShapeFitPowerSpectrumTemplate
    from desilike.observables.galaxy_clustering import TracerPowerSpectrumMultipolesObservable, ObservablesCovarianceMatrix, BoxFootprint
    from desilike.likelihoods import ObservablesGaussianLikelihood
    from desilike.profilers import MinuitProfiler

    template = ShapeFitPowerSpectrumTemplate(z=0.5)
    theory = EFTLikeKaiserTracerPowerSpectrumMultipoles(template=template)
    for param in theory.init.params.select(basename=['ct*', 'sn*']): param.update(fixed=True)
    observable = TracerPowerSpectrumMultipolesObservable(klim={0: [0.05, 0.2, 0.01], 2: [0.05, 0.2, 0.01]},
                                                         data={'ct0_2': 1., 'sn0': 1000.},
                                                         theory=theory)
    covariance = ObservablesCovarianceMatrix(observables=observable, footprints=BoxFootprint(volume=1e10, nbar=1e-2))
    observable.init.update(covariance=covariance())
    likelihood = ObservablesGaussianLikelihood(observables=[observable])
    likelihood.params['LRG.loglikelihood'] = likelihood.params['LRG.logprior'] = {}

    for param in likelihood.all_params.select(basename=['df', 'dm']): param.update(fixed=True)
    profiler = MinuitProfiler(likelihood, rescale=True)
    profiles = profiler.maximize(niterations=1)
    from desilike.theories.galaxy_clustering import ShapeFitPowerSpectrumTemplate, KaiserTracerPowerSpectrumMultipoles
    theory = KaiserTracerPowerSpectrumMultipoles(template=ShapeFitPowerSpectrumTemplate(z=1.))
    theory()
    # theory behaves like any function for jax
    import jax
    from jax import numpy as jnp
    jac = jax.jacfwd(theory)  # jacobian function
    jac = jax.jit(jac)  # just-in-time compilation
    dpoles = jac(dict(dm=0., qpar=1., qper=1.))  # return jacobian
    vtheory = jax.vmap(lambda p: theory(p, return_derived=True))  # vectorized theory, also returning derived parameters
    poles, derived = vtheory(dict(dm=jnp.linspace(0., 0.01, 10)))
    print(poles)


def test_inference():
    # cosmosis, montepython
    assert os.getenv('COSMOSIS_STD_DIR')
    assert os.getenv('CLASS_STD_DIR')
    assert os.getenv('PLANCK_SRC_DIR')

    # cobaya
    from cosmoprimo.fiducial import DESI
    cosmo = DESI()

    # No magic here, this is all Cobaya stuff
    params = {'Omega_m': {'prior': {'min': 0.1, 'max': 1.},
                          'ref': {'dist': 'norm', 'loc': 0.3, 'scale': 0.01},
                          'latex': r'\Omega_{m}'},
              'omega_b': cosmo['omega_b'],
              'H0': cosmo['H0'],
              'A_s': cosmo['A_s'],
              'n_s': cosmo['n_s'],
              'tau_reio': cosmo['tau_reio']}

    info = {'params': params,
            'likelihood': {'planck_2018_highl_plik.TTTEEE': None, 'sn.pantheon': None},
            'theory': {'classy': {'extra_args': {'m_ncdm': cosmo['m_ncdm'][0], 'N_ncdm': cosmo['N_ncdm'], 'N_ur': cosmo['N_ur']}}}}

    info_sampler = {'evaluate': {}}
    from cobaya.model import get_model
    from cobaya.sampler import get_sampler

    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    info['likelihood'] = {'planck_2018_highl_CamSpec2021.TTTEEE': None, 'planckpr4lensing.PlanckPR4Lensing': None}
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    info['likelihood'] = {'planck_NPIPE_highl_CamSpec.TTTEEE': None, 'planckpr4lensing.PlanckPR4LensingMarged': None}
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    info['likelihood'] = {'planck_NPIPE_highl_CamSpec.TEEE': None, 'planckpr4lensing.PlanckPR4LensingMarged': None}
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    info['likelihood'] = {'planck_2020_hillipop.TTTEEE': None, 'planckpr4lensing.PlanckPR4LensingMarged': None}
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    info['likelihood'] = {'act_dr6_lenslike.ACTDR6LensLike': {'lens_only': False, 'stop_at_error': True, 'lmax': 4000, 'variant': 'act_baseline'}}
    info['theory']['classy']['extra_args'].update({'modes': 's', 'output': 'tCl, pCl, lCl'})
    info['debug'] = True
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    #info['params']['yp2'] = {'prior': {'min': 0.5, 'max': 1.5}}  # for ACT
    info['likelihood'] = {'wmaplike.WMAPLike': None, 'spt3g_2020.TEEE': None}  # , 'pyactlike.ACTPol_lite_DR4': None theory deprecated
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    #info['params']['yp2'] = {'prior': {'min': 0.5, 'max': 1.5}}  # for ACT
    info['likelihood'] = {'wmaplike.WMAPLike': None, 'spt3g_2022.TTTEEE': None}
    model = get_model(info)
    get_sampler(info_sampler, model=model).run()

    from pypolychord import settings


def test_desihub():
    from fiberassign.hardware import load_hardware, get_default_exclusion_margins
    from fiberassign._internal import Hardware
    from fiberassign.tiles import load_tiles
    from fiberassign.targets import Targets, TargetsAvailable, LocationsAvailable, create_tagalong, load_target_file, targets_in_tiles
    from fiberassign.assign import Assignment
    from fiberassign.utils import Logger
    from desitarget.io import read_targets_in_tiles
    import desimodel.focalplane
    import desimodel.footprint
    import desimeter


if __name__ == '__main__':
    from mockfactory import setup_logging
    setup_logging()

    test_cosmoprimo()
    test_pycorr()
    test_pypower()
    test_pyrecon()
    test_mockfactory()
    test_desilike()
    test_inference()
    test_abacusutils()
    test_desihub()
