FROM python:3.12-slim AS builder

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update --quiet \
    && apt-get install --yes --quiet --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.9 /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

RUN uv venv /boltz_venv

RUN uv pip install "boltz[cuda]"

FROM python:3.12-slim

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update --quiet \
    && apt-get install --yes --quiet --no-install-recommends procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /boltz_venv /boltz_venv
ENV PATH="/boltz_venv/bin:$PATH"

CMD [ "bash" ]
