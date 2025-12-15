#!/bin/bash

# Script để chạy tất cả các service

# Lấy đường dẫn thư mục gốc
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Danh sách các service
SERVICES=("gateway" "users" "logger" "payment")

# Màu sắc cho output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Bắt đầu chạy các service trong terminal riêng...${NC}\n"

# Tạo thư mục logs nếu chưa có
mkdir -p "$ROOT_DIR/logs"

# Duyệt qua từng service và mở terminal riêng
for service in "${SERVICES[@]}"; do
    SERVICE_DIR="$ROOT_DIR/$service"
    
    # Kiểm tra thư mục service có tồn tại không
    if [ ! -d "$SERVICE_DIR" ]; then
        echo -e "${RED}⚠️  Cảnh báo: Thư mục $service không tồn tại, bỏ qua...${NC}"
        continue
    fi
    
    # Kiểm tra package.json có tồn tại không
    if [ ! -f "$SERVICE_DIR/package.json" ]; then
        echo -e "${RED}⚠️  Cảnh báo: Không tìm thấy package.json trong $service, bỏ qua...${NC}"
        continue
    fi
    
    echo -e "${GREEN}📦 Đang mở terminal cho service: $service${NC}"
    
    # Mở terminal riêng cho mỗi service
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="$service" -- bash -c "cd '$SERVICE_DIR' && npm run start:dev; exec bash" &
    elif command -v xterm &> /dev/null; then
        xterm -T "$service" -e "cd '$SERVICE_DIR' && npm run start:dev; exec bash" &
    elif command -v x-terminal-emulator &> /dev/null; then
        x-terminal-emulator -e bash -c "cd '$SERVICE_DIR' && npm run start:dev; exec bash" &
    else
        # Fallback: chạy background và ghi log
        echo -e "   → Chạy background (không tìm thấy terminal emulator)"
        cd "$SERVICE_DIR" || continue
        npm run start:dev > "$ROOT_DIR/logs/$service.log" 2>&1 &
        SERVICE_PID=$!
        echo -e "   → PID: $SERVICE_PID"
        echo -e "   → Log: $ROOT_DIR/logs/$service.log"
        cd "$ROOT_DIR" || exit 1
    fi
    
    echo ""
    
    # Đợi một chút để terminal khởi động
    sleep 0.5
done

echo -e "\n${GREEN}✨ Hoàn tất!${NC}\n"
