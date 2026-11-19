# Minimal utility image for Nextflow tasks (wget, tar, touch, rm, ...).
# requires bash and a procps `ps` (used for task metrics).
FROM alpine:3.24

RUN apk add --no-cache bash procps

CMD ["bash"]
