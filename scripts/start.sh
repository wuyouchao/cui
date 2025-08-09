#!/bin/bash

# CUI服务启动脚本

echo "========================================="
echo "CUI Web UI 服务启动脚本"
echo "========================================="

# 检查Node.js版本
NODE_VERSION=$(node -v)
echo "Node.js版本: $NODE_VERSION"

# 设置工作目录
cd /data/workspace/services/cui

# 检查PM2
if ! command -v pm2 &> /dev/null; then
    echo "错误: PM2未安装，请先安装PM2"
    exit 1
fi

# 停止已有的CUI服务
echo "检查并停止已有的CUI服务..."
pm2 stop cui-server 2>/dev/null || true
pm2 delete cui-server 2>/dev/null || true

# 启动服务
echo "启动CUI服务..."
pm2 start ecosystem.config.js

# 保存PM2配置
pm2 save

# 生成访问token
TOKEN=$(openssl rand -hex 16)
echo "TOKEN=$TOKEN" > /data/workspace/.cui/.env

# 显示状态
echo ""
echo "========================================="
echo "CUI服务已启动!"
echo "========================================="
echo ""
echo "访问地址: http://localhost:3010"
echo "访问Token: $TOKEN"
echo ""
echo "使用方式:"
echo "  浏览器访问: http://localhost:3010/#$TOKEN"
echo ""
echo "查看日志:"
echo "  pm2 logs cui-server"
echo ""
echo "查看状态:"
echo "  pm2 status cui-server"
echo ""
echo "停止服务:"
echo "  pm2 stop cui-server"
echo ""