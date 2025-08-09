#!/bin/bash

# CUI服务PM2启动脚本

echo "========================================="
echo "CUI Web UI 服务管理脚本"
echo "========================================="

# 启用GCC 11
source /opt/rh/gcc-toolset-11/enable

# 设置工作目录
cd /data/workspace/services/cui

# 检查PM2
if ! command -v pm2 &> /dev/null; then
    echo "错误: PM2未安装"
    exit 1
fi

# 停止已有的CUI服务
echo "检查并停止已有的CUI服务..."
pm2 stop cui-server 2>/dev/null || true
pm2 delete cui-server 2>/dev/null || true

# 启动服务
echo "启动CUI服务..."
pm2 start dist/server.js \
    --name cui-server \
    --interpreter node \
    --max-memory-restart 2G \
    --time \
    --log /data/workspace/.cui/logs/cui.log \
    --error /data/workspace/.cui/logs/cui-error.log \
    --output /data/workspace/.cui/logs/cui-out.log \
    -- --port 3010 --host 0.0.0.0

# 保存PM2配置
pm2 save

# 显示状态
echo ""
echo "========================================="
echo "CUI服务已启动!"
echo "========================================="
echo ""
echo "访问地址: http://localhost:3010"
echo "访问Token: e19dfdcc5a026550d7e94a287b0eeb7a"
echo ""
echo "使用方式:"
echo "  浏览器访问: http://localhost:3010/#token=e19dfdcc5a026550d7e94a287b0eeb7a"
echo ""
echo "管理命令:"
echo "  查看日志: pm2 logs cui-server"
echo "  查看状态: pm2 status cui-server"
echo "  重启服务: pm2 restart cui-server"
echo "  停止服务: pm2 stop cui-server"
echo ""
echo "配置文件:"
echo "  CUI配置: /data/workspace/.cui/config.json"
echo "  日志目录: /data/workspace/.cui/logs/"
echo ""