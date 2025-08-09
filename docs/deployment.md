# CUI服务部署文档

> 最后更新: 2025-08-10
> 部署环境: TencentOS Server 3.2 / Docker容器

## 概述

CUI (Claude UI) 是一个为Claude Code提供的Web用户界面，用于管理和监控Claude Code会话，支持历史记录查看、任务分支、后台运行等功能。

## 环境依赖

### 运行时依赖
- **Node.js**: v20.19.4 或更高版本
- **npm**: 10.8.2 或更高版本
- **PM2**: 进程管理器（用于生产环境）

### 编译依赖
- **GCC 11+**: 支持C++20标准（用于编译better-sqlite3）
- **Python**: 3.6+ （node-gyp依赖）
- **Make**: GNU Make工具

## 部署步骤

### 1. 安装GCC 11工具链

由于better-sqlite3需要C++20支持，需要先升级GCC：

```bash
# 安装gcc-toolset-11
sudo yum install -y gcc-toolset-11 gcc-toolset-11-gcc-c++

# 启用GCC 11环境
source /opt/rh/gcc-toolset-11/enable

# 验证版本
gcc --version  # 应显示 11.2.1 或更高
```

### 2. 克隆项目

```bash
cd /data/workspace/services
git clone https://github.com/wbopan/cui.git
cd cui
```

### 3. 安装依赖

```bash
# 启用GCC 11环境
source /opt/rh/gcc-toolset-11/enable

# 安装npm依赖
npm install

# 如果better-sqlite3编译失败，手动重建
npm rebuild better-sqlite3
```

### 4. 构建项目

```bash
# 构建生产版本
npm run build
```

### 5. 配置服务

创建配置文件 `/data/workspace/.cui/config.json`：

```json
{
  "host": "0.0.0.0",
  "port": 3010,
  "workspaceRoot": "/data/workspace",
  "allowedPaths": [
    "/data/workspace/services"
  ],
  "claudeHistoryPath": "/data/workspace/.claude",
  "dataDir": "/data/workspace/.cui",
  "authToken": null,
  "security": {
    "enableAuth": true,
    "cors": {
      "origin": ["http://localhost:3010", "http://127.0.0.1:3010"],
      "credentials": true
    }
  }
}
```

### 6. 启动服务

#### 开发模式（临时测试）
```bash
source /opt/rh/gcc-toolset-11/enable
npm run dev
```

#### 生产模式（使用PM2）
```bash
# 使用启动脚本
/data/workspace/services/cui/start-cui.sh

# 或手动启动
pm2 start dist/server.js \
    --name cui-server \
    -- --port 3010 --host 0.0.0.0
```

## 访问信息

- **访问地址**: http://localhost:3010
- **认证Token**: e19dfdcc5a026550d7e94a287b0eeb7a
- **完整URL**: http://localhost:3010/#token=e19dfdcc5a026550d7e94a287b0eeb7a

## 管理命令

### PM2进程管理
```bash
# 查看服务状态
pm2 status cui-server

# 查看实时日志
pm2 logs cui-server

# 重启服务
pm2 restart cui-server

# 停止服务
pm2 stop cui-server

# 删除服务
pm2 delete cui-server

# 保存PM2配置（开机自启）
pm2 save
pm2 startup
```

### 日志管理
```bash
# 查看日志文件
tail -f /data/workspace/.cui/logs/cui.log
tail -f /data/workspace/.cui/logs/cui-error.log

# 清理日志
pm2 flush cui-server
```

## 故障排查

### 问题1: better-sqlite3编译失败

**症状**: 
```
error: unrecognized command line option '-std=c++20'
```

**解决方案**:
```bash
# 确保启用GCC 11
source /opt/rh/gcc-toolset-11/enable
gcc --version  # 确认版本>=11

# 重新编译
npm rebuild better-sqlite3
```

### 问题2: 端口被占用

**症状**:
```
Error: listen EADDRINUSE: address already in use
```

**解决方案**:
```bash
# 检查端口占用
netstat -tlnp | grep 3010

# 使用其他端口
node dist/server.js --port 3011 --host 0.0.0.0
```

### 问题3: MCP服务文件缺失

**症状**:
```
MCP server file not found: dist/mcp-server/index.js
```

**解决方案**:
```bash
# 重新构建项目
npm run build

# 确认文件存在
ls -la dist/mcp-server/
```

### 问题4: 权限认证失败

**症状**: 无法访问Web界面，提示认证失败

**解决方案**:
1. 检查token是否正确
2. 查看配置文件 `/data/workspace/.cui/config.json`
3. 使用正确的URL格式: `http://localhost:3010/#token=YOUR_TOKEN`

## 配置说明

### 端口配置
- 默认端口: 3001
- 推荐端口: 3010（避免冲突）
- 可通过命令行参数修改: `--port 3010`

### 工作目录限制
- `workspaceRoot`: 限制CUI只能访问指定目录
- `allowedPaths`: 白名单目录列表

### 安全配置
- `enableAuth`: 启用token认证
- `authToken`: 自定义认证token（null表示自动生成）
- `cors`: 跨域访问配置

## 目录结构

```
/data/workspace/services/cui/
├── dist/                  # 构建输出
├── src/                   # 源代码
├── node_modules/          # 依赖包
├── start-cui.sh          # 启动脚本
├── ecosystem.config.js    # PM2配置
└── docs/                  # 文档
    └── deployment.md      # 本文档

/data/workspace/.cui/
├── config.json           # 服务配置
├── logs/                 # 日志目录
└── session-info.db       # 会话数据库
```

## 更新升级

```bash
# 停止服务
pm2 stop cui-server

# 更新代码
cd /data/workspace/services/cui
git pull

# 重新安装依赖和构建
source /opt/rh/gcc-toolset-11/enable
npm install
npm run build

# 重启服务
pm2 restart cui-server
```

## 相关链接

- [CUI原始仓库](https://github.com/wbopan/cui) (上游)
- [CUI定制Fork](https://github.com/wuyouchao/cui) (当前使用)
- [Claude Code文档](https://docs.anthropic.com/en/docs/claude-code)
- [PM2文档](https://pm2.keymetrics.io/)

## GitHub Token缓存配置

为了避免每次推送都输入token，可以选择以下方案之一：

**方案1：URL配置（推荐，最方便）**
```bash
# 将token直接配置在远程URL中
git remote set-url origin https://wuyouchao:YOUR_GITHUB_TOKEN@github.com/wuyouchao/cui.git

# 以后直接push，不需要输入密码
git push
```

**方案2：凭证缓存**
```bash
# 缓存8小时（工作时间够用）
git config --global credential.helper 'cache --timeout=28800'

# 或永久存储（注意安全性）
git config --global credential.helper store
```

**验证配置**
```bash
git config --global credential.helper
git remote -v
```