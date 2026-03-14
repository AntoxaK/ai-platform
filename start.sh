#!/bin/bash
#
# AI Platform - Start Script
# Starts ComfyUI (host) + SwarmUI & Ollama (Docker)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

PLATFORM_VERSION=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "dev")
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   AI Platform v${PLATFORM_VERSION}$(printf '%*s' $((22-${#PLATFORM_VERSION})) '')║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""

# --- Pre-flight checks ---

# Check Docker
if ! docker info &> /dev/null; then
    log_error "Docker daemon not running"
    exit 1
fi

# Check GPU
if command -v nvidia-smi &> /dev/null; then
    log_info "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)"
else
    log_warn "nvidia-smi not found"
fi

# --- Start ComfyUI on host ---

COMFY_DIR="$SCRIPT_DIR/dlbackend/ComfyUI"
COMFY_LOG="/tmp/comfyui.log"
COMFY_PID="/tmp/comfyui.pid"

# Check if already running
if [ -f "$COMFY_PID" ] && kill -0 "$(cat "$COMFY_PID")" 2>/dev/null; then
    log_info "ComfyUI already running (PID: $(cat "$COMFY_PID"))"
else
    log_info "Starting ComfyUI..."

    if [ ! -d "$COMFY_DIR/venv" ]; then
        log_error "ComfyUI venv not found at $COMFY_DIR/venv"
        log_error "Run: cd $COMFY_DIR && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
        exit 1
    fi

    cd "$COMFY_DIR"
    source venv/bin/activate
    nohup python main.py --listen 127.0.0.1 --port 7821 \
        --extra-model-paths-config "$SCRIPT_DIR/dlbackend/extra_model_paths.yaml" > "$COMFY_LOG" 2>&1 &
    echo $! > "$COMFY_PID"
    cd "$SCRIPT_DIR"

    log_info "ComfyUI started (PID: $(cat "$COMFY_PID"))"

    # Wait for ComfyUI to be ready
    log_info "Waiting for ComfyUI..."
    for i in {1..30}; do
        if curl -s http://127.0.0.1:7821 > /dev/null 2>&1; then
            log_info "ComfyUI ready!"
            break
        fi
        sleep 1
    done
fi

# --- Start SwarmUI & Ollama in Docker ---

log_info "Starting Docker services (SwarmUI + Ollama)..."

export HOST_UID=$(id -u)
export HOST_GID=$(id -g)

docker compose up -d

# Wait for SwarmUI startup
sleep 3

# Wait for Ollama to be ready (Docker container health check)
log_info "Waiting for Ollama..."
for i in {1..30}; do
    if curl -s http://127.0.0.1:11434/api/tags > /dev/null 2>&1; then
        log_info "Ollama ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        log_warn "Ollama startup timeout (may still be loading)"
    fi
    sleep 1
done

# Check status
if docker compose ps --format json 2>/dev/null | grep -q '"State":"running"'; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  AI Platform Started!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "  SwarmUI: http://127.0.0.1:7801"
    echo "  ComfyUI: http://127.0.0.1:7821"
    echo "  Ollama:  http://127.0.0.1:11434"
    echo ""
    echo "  Logs:"
    echo "    ComfyUI: tail -f $COMFY_LOG"
    echo "    SwarmUI: docker compose logs -f swarmui"
    echo "    Ollama:  docker compose logs -f ollama"
    echo ""
    echo "  First time? Download a coding model:"
    echo "    docker exec -it ollama ollama pull qwen2.5-coder:7b"
    echo ""
else
    log_error "Docker services failed to start"
    docker compose logs --tail 20
    exit 1
fi
