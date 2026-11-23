FROM debian:bookworm-slim AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN curl -fsSL -o model.llamafile \
    https://huggingface.co/Mozilla/TinyLlama-1.1B-Chat-v1.0-llamafile/resolve/main/TinyLlama-1.1B-Chat-v1.0.Q4_K_M.llamafile \
    && echo "29eca81f9f3a639029aa1f35cb1f28a9411aafbc54f12b920ca904177177a965  model.llamafile" | sha256sum -c - \
    && chmod 755 model.llamafile

FROM debian:bookworm-slim

RUN useradd -u 1000 -m -s /bin/sh llamafile

WORKDIR /home/llamafile

COPY --from=builder --chown=llamafile:llamafile /build/model.llamafile /home/llamafile/model.llamafile

USER llamafile
ENV HOME=/home/llamafile

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "/home/llamafile/model.llamafile"]
CMD ["--server", "--nobrowser", "--host", "0.0.0.0", "--port", "8080", "--unsecure", "-c", "256", "-t", "1"]