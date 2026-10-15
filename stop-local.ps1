$ErrorActionPreference = 'SilentlyContinue'

foreach ($port in 18080, 13000) {
  $connections = Get-NetTCPConnection -LocalPort $port -State Listen
  $connections | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object {
    Stop-Process -Id $_ -Force
  }
}

Write-Host 'Stopped local Sub2API frontend/backend listeners on ports 13000 and 18080.'
