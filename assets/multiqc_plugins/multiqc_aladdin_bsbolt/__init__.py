#! /usr/bin/env python

from pkg_resources import get_distribution
from multiqc.utils import config

__version__ = get_distribution("multiqc_aladdin_bsbolt").version
config.multiqc_aladdin_bsbolt_version = __version__
