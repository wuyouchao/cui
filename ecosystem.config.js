export default {
  apps: [{
    name: 'cui-server',
    script: 'npm',
    args: 'run dev',
    cwd: '/data/workspace/services/cui',
    env: {
      NODE_ENV: 'development',
      PORT: 3010,
      CUI_CONFIG_PATH: '/data/workspace/.cui/config.json',
      WORKSPACE_ROOT: '/data/workspace',
      LOG_LEVEL: 'info'
    },
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '2G',
    error_file: '/data/workspace/.cui/logs/error.log',
    out_file: '/data/workspace/.cui/logs/out.log',
    log_file: '/data/workspace/.cui/logs/combined.log',
    time: true
  }]
};