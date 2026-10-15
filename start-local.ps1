$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $root '.env.local'

if (-not (Test-Path -LiteralPath $envFile)) {
  throw 'Missing .env.local. Create it from the local setup output before starting.'
}

Get-Content -LiteralPath $envFile | ForEach-Object {
  if ($_ -match '^([^#=]+)=(.*)$') {
    [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
  }
}

wsl -d Ubuntu -- pg_ctlcluster 16 main start 2>$null

if (-not (Get-Process redis-server -ErrorAction SilentlyContinue)) {
  Start-Process -FilePath 'D:\Redis\Redis-8.2.5\redis-server.exe' `
    -ArgumentList '--bind','127.0.0.1','--port','6379','--dir',(Join-Path $root '.dev'),'--appendonly','yes' `
    -WindowStyle Hidden
}

if (-not (Get-NetTCPConnection -LocalPort 18080 -State Listen -ErrorAction SilentlyContinue)) {
  Start-Process -FilePath 'go.exe' -ArgumentList 'run','./cmd/server' `
    -WorkingDirectory (Join-Path $root 'backend') -WindowStyle Hidden
}

if (-not (Get-NetTCPConnection -LocalPort 13000 -State Listen -ErrorAction SilentlyContinue)) {
  Start-Process -FilePath 'node.exe' -ArgumentList 'node_modules/vite/bin/vite.js' `
    -WorkingDirectory (Join-Path $root 'frontend') -WindowStyle Hidden
}

Write-Host 'Sub2API local services started:'
Write-Host '  Frontend: http://127.0.0.1:13000/'
Write-Host '  Backend:  http://127.0.0.1:18080/health'
