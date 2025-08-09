# CUI服务部署状态

> 部署时间: 2025-08-10
> 服务状态: ✅ 运行中

## 快速访问

🌐 **访问地址**: http://localhost:3010/#token=e19dfdcc5a026550d7e94a287b0eeb7a

## 服务信息

| 项目 | 值 |
|------|-----|
| 服务名称 | cui-server |
| 进程管理 | PM2 |
| 端口 | 3010 |
| 监听地址 | 0.0.0.0 |
| 认证Token | e19dfdcc5a026550d7e94a287b0eeb7a |
| 配置文件 | /data/workspace/.cui/config.json |
| 日志目录 | /data/workspace/.cui/logs/ |

## 快速命令

### 启动服务
```bash
/data/workspace/services/cui/start-cui.sh
```

### 查看状态
```bash
pm2 status cui-server
```

### 查看日志
```bash
pm2 logs cui-server
```

### 重启服务
```bash
pm2 restart cui-server
```

### 停止服务
```bash
pm2 stop cui-server
```

## 功能特性

✅ **已配置功能**:
- Claude Code会话历史管理
- 任务分支和恢复
- 后台任务运行
- Token认证保护
- 工作目录限制 (/data/workspace)

❌ **未启用功能**:
- Gemini语音输入（需要GOOGLE_API_KEY）
- 推送通知（需要配置ntfy）

## 常见操作

### 修改访问Token

1. 编辑配置文件:
```bash
vim /data/workspace/.cui/config.json
```

2. 修改 `authToken` 字段（设为null自动生成）

3. 重启服务:
```bash
pm2 restart cui-server
```

### 修改端口

```bash
# 方式1: 修改配置文件中的port字段
vim /data/workspace/.cui/config.json

# 方式2: 使用命令行参数
pm2 delete cui-server
pm2 start dist/server.js --name cui-server -- --port 3011
```

### 查看当前运行的Claude任务

1. 访问 http://localhost:3010/#token=e19dfdcc5a026550d7e94a287b0eeb7a
2. 点击 "Tasks" 标签页
3. 查看所有运行中的任务

## 故障快速恢复

如果服务异常，执行以下命令：

```bash
# 1. 启用GCC 11环境
source /opt/rh/gcc-toolset-11/enable

# 2. 进入项目目录
cd /data/workspace/services/cui

# 3. 重启服务
pm2 delete cui-server
pm2 start dist/server.js --name cui-server -- --port 3010 --host 0.0.0.0
pm2 save
```

## 相关文件位置

- **项目目录**: `/data/workspace/services/cui/`
- **配置文件**: `/data/workspace/.cui/config.json`
- **日志文件**: `/data/workspace/.cui/logs/`
- **启动脚本**: `/data/workspace/services/cui/start-cui.sh`
- **部署文档**: `/data/workspace/services/cui/docs/deployment.md`

## 维护联系

- 部署文档: [deployment.md](./docs/deployment.md)
- 系统环境: [/data/workspace/docs/system/environment.md](/data/workspace/docs/system/environment.md)
- GitHub仓库: https://github.com/wbopan/cui