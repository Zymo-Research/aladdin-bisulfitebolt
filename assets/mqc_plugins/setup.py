#!/usr/bin/env python

from setuptools import setup, find_packages


_version = '0.0.1'

setup(
    name='multiqc_custom_plugins',
    version=_version,
    description="Custom MultiQC plugins for ampliseq pipeline",
    packages=find_packages(),
    include_package_data=True,
    install_requires=['multiqc==1.12'],
    entry_points={
        'multiqc.modules.v1': [
            'cutadapt = plugins.modules.cutadapt_ext:MultiqcModule',
        ],
    }
)
