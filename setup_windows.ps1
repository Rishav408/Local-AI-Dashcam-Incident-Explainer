# =============================================================================
#  Local AI Dashcam Incident Explainer — Windows Setup Script
# =============================================================================

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Local AI Dashcam Incident Explainer — Windows Setup" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# -- 1. Python Check ----------------------------------------------------------
$pythonPath = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonPath) {
    Write-Host "[ERROR] Python not found. Please install Python 3.10+ from python.org" -ForegroundColor Red
    exit 1
}
$versionInfo = python --version
Write-Host "[OK] $versionInfo" -ForegroundColor Green

# -- 2. FFmpeg Check ----------------------------------------------------------
$ffmpegPath = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpegPath) {
    Write-Host "[WARN] ffmpeg not found. Keyframe extraction will fail!" -ForegroundColor Yellow
    Write-Host "       Download from: https://github.com/BtbN/FFmpeg-Builds/releases" -ForegroundColor White
    Write-Host "       Extract and add the 'bin' folder to your PATH." -ForegroundColor White
} else {
    Write-Host "[OK] ffmpeg found" -ForegroundColor Green
}

# -- 3. Ollama Check ----------------------------------------------------------
$ollamaPath = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $ollamaPath) {
    Write-Host "[WARN] Ollama not found. VLM/LLM analysis will fail!" -ForegroundColor Yellow
    Write-Host "       Install from: https://ollama.com/" -ForegroundColor White
} else {
    Write-Host "[OK] Ollama found" -ForegroundColor Green
}

# -- 4. Virtual Environment ---------------------------------------------------
if (-not (Test-Path ".venv")) {
    Write-Host "[*] Creating virtual environment..." -ForegroundColor Cyan
    python -m venv .venv
}
Write-Host "[OK] Virtual environment ready" -ForegroundColor Green

# -- 5. Install Dependencies --------------------------------------------------
Write-Host "[*] Installing Python dependencies (this may take a minute)..." -ForegroundColor Cyan
& ".\.venv\Scripts\python.exe" -m pip install --upgrade pip --quiet
& ".\.venv\Scripts\pip.exe" install -r requirements.txt --quiet
Write-Host "[OK] Dependencies installed" -ForegroundColor Green

# -- 6. NLTK Data -------------------------------------------------------------
Write-Host "[*] Downloading NLTK tokenizer..." -ForegroundColor Cyan
& ".\.venv\Scripts\python.exe" -c "import nltk; nltk.download('punkt', quiet=True); nltk.download('punkt_tab', quiet=True)"
Write-Host "[OK] NLTK data ready" -ForegroundColor Green

# -- 7. Create Directories ----------------------------------------------------
Write-Host "[*] Creating output directories..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "outputs/keyframes", "outputs/incidents", "outputs/reports", "data/samples" > $null
Write-Host "[OK] Directories created" -ForegroundColor Green

# -- 8. Pull Models (Optional/Manual) -----------------------------------------
Write-Host ""
Write-Host "Models required (via Ollama):" -ForegroundColor White
Write-Host "  ollama pull minicpm-v" -ForegroundColor Gray
Write-Host "  ollama pull mistral" -ForegroundColor Gray

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ✅  Setup complete!" -ForegroundColor Green
Write-Host "  To run the Web UI:" -ForegroundColor White
Write-Host "  .\.venv\Scripts\python.exe src\phase4\app.py" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
