# SwarmUI Docker build - patched for Debian Bookworm
# Original: swarmui/launchtools/StandardDockerfile.docker
# Fixes:
#   1. Use correct Debian package names (python3 instead of python3.11)
#   2. Use HTTPS apt sources (port 80 may be blocked)

FROM mcr.microsoft.com/dotnet/sdk:8.0-bookworm-slim

ARG UID=1000

# Switch apt sources to HTTPS (fixes networks where port 80 is blocked)
RUN sed -i 's|http://|https://|g' /etc/apt/sources.list.d/debian.sources

# Force public DNS (WSL2/Docker DNS workaround)
# RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
#     echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Install python and dependencies (Debian Bookworm package names)
# Combined into single RUN to avoid cache issues
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    build-essential \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    ffmpeg \
    libglib2.0-0 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Copy swarm's files into the docker container
COPY swarmui/ ./SwarmUI

# Git safety config (needed for dotnet build)
RUN git config --global --add safe.directory '*'

# Pre-build SwarmUI during image build (avoids runtime DNS issues)
# This runs during `docker build --network=host` when HTTPS works
WORKDIR /SwarmUI
ENV HOME=/tmp
RUN dotnet restore && dotnet build -c Release

# Create non-root user
RUN useradd -u $UID swarmui

# Set proper ownership after build
RUN chown -R $UID:$UID ./

WORKDIR /
EXPOSE 7801

ENTRYPOINT ["bash", "/SwarmUI/launchtools/docker-standard-inner.sh"]
