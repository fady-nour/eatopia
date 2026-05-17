# Eatopia

Eatopia is a full-stack nutrition and healthy lifestyle platform built as a portfolio-ready graduation project. It combines authentication, role-based administration, community features, chat, recipes, reminders, AI food scanning, and personalized diet-plan generation.

## Highlights

- Full authentication flow with signup, login, email confirmation support, password reset support, JWT refresh handling, and Google login configuration.
- Three-role access model: Owner / Super Admin, Admin / Manager, and User.
- Admin dashboard for users, admins, reports, community moderation, recipes, and owner-only controls.
- Community feed with posts, comments, likes, follows, reports, moderation actions, notifications, and profile pages.
- Real-time chat using SignalR, including message requests, blocking, reporting, media, and voice notes.
- Recipe library with Egyptian meals, macro data, search, calorie/protein filters, admin add/edit/delete, and full cooking details.
- Diet plan generator based on user profile data, target macros, Egyptian meal suggestions, saved plan state, and PDF export support.
- AI food scan page with non-food handling and adjustable meal grams for more accurate nutrition.
- Automated checks for backend, frontend, recipe data quality, and Playwright E2E flows.

## Tech Stack

- Frontend: React 18, React Router, Axios, React Icons, React Toastify, Playwright.
- Backend: ASP.NET Core 8, EF Core, SQL Server, JWT Auth, SignalR, Serilog.
- AI bridge: Python CLI under `ai/`.
- Tests: xUnit integration tests, Jest/React Testing Library, Playwright E2E.

## Repository Structure

```text
.
|-- Eatopia/                  # ASP.NET Core solution
|   |-- src/
|   |   |-- Eatopia.Api/
|   |   |-- Eatopia.Application/
|   |   |-- Eatopia.Domain/
|   |   `-- Eatopia.Infrastructure/
|   `-- tests/Eatopia.Tests/
|-- frontend-src/             # React app
|-- ai/                       # Python AI bridge and optional model files
|-- scripts/verify-all.ps1    # Local quality gate
`-- .github/workflows/        # GitHub Actions quality gates
```

## Prerequisites

- .NET 8 SDK
- Node.js 20+
- SQL Server Express, LocalDB, or a local SQL Server instance
- Python 3.10+ for AI scan and diet plan commands

## Quick Start

### 1. Clone and install frontend dependencies

```powershell
cd frontend-src
npm install
Copy-Item .env.example .env
```

The default `.env.example` points the frontend to `http://localhost:3001`.

Google login is optional. To enable it, replace `PUT_GOOGLE_CLIENT_ID_HERE` in `frontend-src/.env` and set the same value for `Authentication:Google:ClientId` in the backend configuration or environment variables.

### 2. Start the backend

```powershell
cd Eatopia
dotnet run --project .\src\Eatopia.Api\Eatopia.Api.csproj --urls http://localhost:3001
```

Swagger will be available at:

```text
http://localhost:3001/swagger
```

The backend applies migrations/schema repair on startup in development and seeds the local owner account.

Local owner account:

```text
Email: fadynour194@gmail.com
Password: Admin12345
```

### 3. Start the frontend

Open a second terminal:

```powershell
cd frontend-src
npm start
```

Open:

```text
http://localhost:3000
```

## AI Notes

Diet plan generation works through `ai/eatopia_ai_cli.py`.

For Python dependencies:

```powershell
cd ai
python -m venv .venv
.\.venv\Scripts\pip install -r requirements.txt
```

The large inverse-cooking checkpoint is intentionally ignored by Git:

```text
ai/inversecooking/data/*.ckpt
```

If the checkpoint is missing, the scan flow still returns a safe fallback estimate instead of blocking the rest of the app.

## Quality Gates

Run the main local verification script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-all.ps1
```

Current coverage includes:

- Backend integration/security/schema tests
- Frontend unit tests
- Recipe data-quality checks
- Production frontend build
- Playwright E2E tests

You can skip E2E when you only need a fast smoke check:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-all.ps1 -SkipE2E
```

## GitHub Hygiene

Do not commit:

- `frontend-src/node_modules/`
- `frontend-src/build/`
- `frontend-src/.env`
- `ai/.venv/`
- `ai/inversecooking/data/*.ckpt`
- `bin/`, `obj/`, logs, test-results, uploads, or production secrets

Keep real SMTP passwords, JWT production secrets, Google client ids, and hosting configuration in environment variables or local ignored files.

## Status

This project is ready to be shared as a portfolio/CV repository. For public hosting, configure production environment variables, a real SQL Server database, SMTP credentials, CORS origins, and a public Google OAuth client.
