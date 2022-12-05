FROM python:3.8-slim

RUN apt-get update && apt install -y procps g++ && apt-get clean

RUN mkdir -p /opt/analysis/bin

WORKDIR /opt/analysis

COPY environment.yml /opt/analysis/environment.yml

COPY assets/multiqc_plugins /opt/multiqc_plugins

RUN pip install --no-cache-dir -r environment.yml && cd /opt/multiqc_plugins && python setup.py develop

COPY bin /opt/analysis/bin

ENV PATH="/opt/analysis/bin:$PATH"

CMD ["bash"]