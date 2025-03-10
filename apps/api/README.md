# BHub API - Hướng dẫn chạy và debug

## Cài đặt

1. Đảm bảo bạn đã cài đặt Go 1.21 hoặc cao hơn
2. Clone repository về máy của bạn

## Cấu hình môi trường

Tạo file `.env` trong thư mục `/apps/api` với các biến môi trường sau:

```
APP_ENV=development
FIREBASE_CREDENTIALS_PATH=/đường/dẫn/đến/firebase-credentials.json
GOOGLE_CLOUD_PROJECT=tên-project-của-bạn
PORT=8080
```

Lưu ý:
- Trong môi trường development, các biến `FIREBASE_CREDENTIALS_PATH` và `GOOGLE_CLOUD_PROJECT` là tùy chọn
- Trong môi trường production, các biến này là bắt buộc

## Chạy ứng dụng

### Cách 1: Chạy trực tiếp bằng Go

```bash
cd /Users/mauduckg/Documents/demo/bhub/apps/api
go mod download  # Tải các dependencies
go run cmd/main.go
```

### Cách 2: Build và chạy binary

```bash
cd /Users/mauduckg/Documents/demo/bhub/apps/api
go build -o bhub-api ./cmd/main.go
./bhub-api
```

### Cách 3: Sử dụng Docker

```bash
cd /Users/mauduckg/Documents/demo/bhub/apps/api
docker build -t bhub-api .
docker run -p 8080:8080 --env-file .env bhub-api
```

## Debug ứng dụng

### 1. Sử dụng logging

Thêm các lệnh logging vào code để theo dõi luồng thực thi:

```go
import "log"

// Trong hàm của bạn
log.Printf("Giá trị của biến: %v", someVariable)
```

### 2. Sử dụng Delve debugger

Delve là công cụ debug mạnh mẽ cho Go:

```bash
# Cài đặt Delve
go install github.com/go-delve/delve/cmd/dlv@latest

# Debug ứng dụng
cd /Users/mauduckg/Documents/demo/bhub/apps/api
dlv debug cmd/main.go
```

Các lệnh cơ bản trong Delve:
- `break main.main` - đặt breakpoint tại hàm main
- `break controllers/bhub_controller.go:25` - đặt breakpoint tại dòng 25 trong file
- `continue` hoặc `c` - tiếp tục thực thi
- `next` hoặc `n` - thực thi dòng tiếp theo
- `step` hoặc `s` - bước vào hàm
- `print variableName` - in giá trị biến
- `help` - xem danh sách lệnh

### 3. Sử dụng IDE

Nếu bạn đang sử dụng VSCode hoặc GoLand, bạn có thể sử dụng tính năng debug tích hợp:

#### VSCode
1. Cài đặt extension Go cho VSCode
2. Tạo file `.vscode/launch.json` với nội dung:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch BHub API",
            "type": "go",
            "request": "launch",
            "mode": "auto",
            "program": "${workspaceFolder}/apps/api/cmd/main.go",
            "env": {
                "APP_ENV": "development"
            }
        }
    ]
}
```

3. Đặt breakpoint bằng cách click vào lề trái của editor
4. Nhấn F5 để bắt đầu debug

## Kiểm tra API

Sau khi chạy ứng dụng, bạn có thể kiểm tra API bằng cách gửi request đến:

```
http://localhost:8080/health
```

Nếu API hoạt động, bạn sẽ nhận được phản hồi:

```json
{"status": "ok"}
```

## Các vấn đề thường gặp

### 1. Lỗi kết nối Firebase

Kiểm tra file credentials và đảm bảo quyền truy cập đúng.

### 2. Lỗi port đã được sử dụng

Thay đổi port trong biến môi trường PORT hoặc dừng ứng dụng đang sử dụng port đó.

### 3. Lỗi thiếu dependencies

Chạy `go mod tidy` để cập nhật và tải các dependencies còn thiếu.