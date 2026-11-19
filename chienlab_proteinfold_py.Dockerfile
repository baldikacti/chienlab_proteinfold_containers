FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends procps && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.9 /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

RUN uv venv /opt/venv --python /usr/local/bin/python3.13
ENV PATH="/opt/venv/bin:$PATH"

RUN uv pip install --python /opt/venv/bin/python pandas requests pyyaml numpy numba tqdm

WORKDIR /app

CMD ["bash"]
