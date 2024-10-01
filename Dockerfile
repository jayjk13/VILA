FROM nvcr.io/nvidia/pytorch:24.06-py3

WORKDIR /app

RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh \
    && sh ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

COPY pyproject.toml pyproject.toml
COPY llava llava

COPY environment_setup.sh environment_setup.sh
RUN bash environment_setup.sh vila

COPY server.py server.py

CMD conda run -n vila --no-capture-output python -u -W ignore server.py \
    --model-path ${MODEL_PATH:-Efficient-Large-Model/VILA1.5-40B } \
    --host ${HOST:-0.0.0.0} \
    --port ${PORT:-8000} \
    --conv-mode ${CONV_MODE:-hermes-2} \
    --workers ${WORKERS:-1}
