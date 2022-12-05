#!/usr/bin/env python
import logging

from multiqc import config
from multiqc.utils import report

log = logging.getLogger('multiqc')


def before_config():
    # Use the zymo template by default
    log.info('Load MultiQC report template: zymo')
    config.template = 'aladdin'