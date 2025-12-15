#!/bin/bash

# Script để cài đặt thư viện và copy file .env vào từng project
# Cách sử dụng:
#   ./setup.sh env    - Chỉ copy/ghi đè file .env
#   ./setup.sh full   - Cài lại thư viện và copy file .env

# Lấy đường dẫn thư mục gốc
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$ROOT_DIR/.env"

# Kiểm tra file .env có tồn tại không
if [ ! -f "$ENV_FILE" ]; then
    echo "Lỗi: Không tìm thấy file .env tại $ENV_FILE"
    exit 1
fi

# Xác định chế độ chạy
MODE="${1:-full}"

if [ "$MODE" != "env" ] && [ "$MODE" != "full" ]; then
    echo "Cách sử dụng:"
    echo "  ./setup.sh env   - Chỉ copy/ghi đè file .env"
    echo "  ./setup.sh full  - Cài lại thư viện và copy file .env"
    exit 1
fi

# Danh sách các project
PROJECTS=("gateway" "users" "logger" "payment")

if [ "$MODE" == "env" ]; then
    echo "🔄 Chế độ: Chỉ copy/ghi đè file .env"
else
    echo "🔄 Chế độ: Cài lại thư viện và copy file .env"
fi
echo ""

# Duyệt qua từng project
for project in "${PROJECTS[@]}"; do
    PROJECT_DIR="$ROOT_DIR/$project"
    
    # Kiểm tra thư mục project có tồn tại không
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "⚠️  Cảnh báo: Thư mục $project không tồn tại, bỏ qua..."
        continue
    fi
    
    echo "📦 Đang xử lý project: $project"
    echo "   → Di chuyển vào thư mục $project"
    cd "$PROJECT_DIR" || exit 1
    
    # Kiểm tra package.json có tồn tại không
    if [ ! -f "package.json" ]; then
        echo "   ⚠️  Cảnh báo: Không tìm thấy package.json trong $project, bỏ qua..."
        cd "$ROOT_DIR"
        continue
    fi
    
    # Cài đặt thư viện (chỉ khi mode = full)
    if [ "$MODE" == "full" ]; then
        echo "   → Đang cài đặt thư viện (npm install)..."
        npm install
        
        if [ $? -eq 0 ]; then
            echo "   ✅ Cài đặt thư viện thành công"
        else
            echo "   ❌ Lỗi khi cài đặt thư viện"
        fi
    fi
    
    # Copy file .env
    echo "   → Đang copy/ghi đè file .env..."
    cp "$ENV_FILE" "$PROJECT_DIR/.env"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Copy file .env thành công"
    else
        echo "   ❌ Lỗi khi copy file .env"
    fi
    
    echo ""
    
    # Quay lại thư mục gốc
    cd "$ROOT_DIR" || exit 1
done

echo "✨ Hoàn tất cài đặt cho tất cả các project!"

