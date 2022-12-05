#!/usr/bin/env python
"""
Setup code for Aladdin BSBolt pipeline MultiQC plugin.
For more information about MultiQC, see http://multiqc.info
"""

from setuptools import setup, find_packages

version = '1.0.0'

setup(
    name = 'multiqc_aladdin_bsbolt',
    version = version,
    description = "MultiQC plugins for bsbolt pipeline",
    packages = find_packages(),
    include_package_data = True,
    install_requires = ['multiqc==1.9'],
    entry_points = {
        'multiqc.templates.v1': [
            'aladdin = multiqc_aladdin_bsbolt.templates.aladdin'
        ],
        'multiqc.hooks.v1': [
            'before_config = utils.hooks:before_config',
        ],
    }
)
