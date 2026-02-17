FROM golang:1.25 AS builder

WORKDIR /app

# 下載並切換到指定版本 (使用 --depth 1 加快下載速度)
RUN git clone --branch v1.3.1 --depth 1 https://github.com/juicedata/juicefs.git .

# 編譯
RUN make

FROM alpine:3.23

# 安裝必要的執行依賴 (ca-certificates 用於 HTTPS, fuse3 用於掛載)
RUN apk add --no-cache ca-certificates fuse3

COPY --from=builder /app/juicefs /usr/local/bin/juicefs

ENTRYPOINT ["juicefs"]
