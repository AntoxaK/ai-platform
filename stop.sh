#!/bin/bash
#
# AI Platform - Stop Script
# Stops SwarmUI & Ollama (Docker) + ComfyUI (host)
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

show_help() {
    echo "Usage: ./stop.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --purge     Remove Docker volumes (will need to reinstall Swarm nodes)"
    echo "  --help      Show this help"
}

PURGE=false
for arg in "$@"; do
    case $arg in
        --purge) PURGE=true ;;
        --help)  show_help; exit 0 ;;
    esac
done

# --- Stop Docker services (SwarmUI + Ollama) ---

log_info "Stopping Docker services (SwarmUI + Ollama)..."
docker compose down 2>/dev/null || true

# --- Stop ComfyUI (host) ---

COMFY_PID="/tmp/comfyui.pid"

if [ -f "$COMFY_PID" ]; then
    PID=$(cat "$COMFY_PID")
    if kill -0 "$PID" 2>/dev/null; then
        log_info "Stopping ComfyUI (PID: $PID)..."
        kill "$PID" 2>/dev/null || true
        sleep 2
        kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f "$COMFY_PID"
fi

# Kill any remaining ComfyUI processes
pkill -f "python.*main.py.*7821" 2>/dev/null || true

# --- Optional cleanup ---

if [ "$PURGE" = true ]; then
    log_warn "Removing Docker volumes..."
    docker volume rm swarmui-dlnodes swarmui-extensions 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}AI Platform stopped.${NC}"
echo ""
echo "Preserved:"
echo "  models/        - Image generation models"
echo "  ollama-models/ - LLM models"
echo "  output/        - Generated images"
echo "  data/          - Configuration"
