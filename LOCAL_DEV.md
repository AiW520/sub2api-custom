# Local Development

The local instance uses WSL Ubuntu PostgreSQL, the existing Windows Redis installation, and native Go/Vite processes.

```powershell
.\start-local.ps1
```

Open `http://127.0.0.1:13000/`. The backend health endpoint is `http://127.0.0.1:18080/health`.

Local credentials and generated secrets are stored in the ignored `.env.local` file. Payment providers are disabled until merchant configuration is supplied.

```powershell
.\stop-local.ps1
```
