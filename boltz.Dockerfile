FROM python:3.12-slim

# build-essential is needed: ihm (via modelcif) has a C extension with no wheel.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update --quiet \
    && apt-get install --yes --quiet --no-install-recommends build-essential procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.9 /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never \
    VIRTUAL_ENV=/boltz_venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# VIRTUAL_ENV "activates" the venv so `uv pip install` targets it
# (otherwise uv only looks for ./.venv and fails with "No virtual environment found").
RUN uv venv $VIRTUAL_ENV --python /usr/local/bin/python3.12

RUN uv pip install "boltz[cuda]"

CMD [ "bash" ]
