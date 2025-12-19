# PDF to JPEG — Easy Guide (Windows)

This simple tool converts any PDF into JPEG images. It’s designed for non-technical users: pick a PDF, wait a moment, and it opens the folder with the pictures.

## What You’ll Get
- Each PDF page becomes a separate `.jpg` image
- Images are saved in a `jpg` folder next to your PDF
- The folder opens automatically when it’s done

## Quick Start (Easiest)
1. Click the green **Code** button on this page and choose **Download ZIP**.
2. Save the ZIP and **Extract** it (right-click → Extract All…).
3. Open the extracted folder and **double‑click** `Run-Me.bat`.
4. When asked, **choose the PDF** you want to convert.
5. Wait a bit — a folder named `jpg` will open with your pictures.

> Note: The first run may install free tools automatically (ImageMagick + Ghostscript) using **winget**. If Windows asks for permission, click **Yes**.

## Install On Your PC (Step‑by‑Step)
Follow these steps once, then you can use it any time:

1. Open this page and click **Code → Download ZIP**.
2. In your Downloads, **right‑click** the ZIP → **Extract All…** → choose a location like **Documents** or **Desktop**.
3. Open the extracted folder. If Windows shows a blue warning (SmartScreen): click **More info** → **Run anyway**.
4. **Double‑click** `Run-Me.bat`. If Windows asks for permission or admin approval, click **Yes**.
5. On first run, it may install free tools (ImageMagick + Ghostscript) using **winget**. This is safe and only happens once.
6. When prompted, **pick your PDF**. The pictures will appear in a new `jpg` folder.

### Keep It Handy (Desktop Shortcut)
- Right‑click `Run-Me.bat` → **Show more options** → **Send to** → **Desktop (create shortcut)**.
- On your Desktop, you can rename the shortcut to “PDF to JPEG”. Double‑click it any time you need it.

### If Winget Is Missing
- Install Microsoft **App Installer** from the **Microsoft Store** (search “App Installer”).
- After install, run `Run-Me.bat` again.

## If `Run-Me.bat` Doesn’t Work
You can also run the PowerShell script directly:

- Right‑click `Convert-PdfToJpeg.ps1` → **Run with PowerShell**
- Or open Start → type **PowerShell** → open it, then run:

```powershell
# Change to the folder you extracted
cd "C:\Path\To\PDF-to-JPEG"

# Run the script (temporarily bypasses execution policy)
powershell -ExecutionPolicy Bypass -File .\Convert-PdfToJpeg.ps1
```

## Optional Settings (Advanced)
If you want to set quality or choose the output folder, you can provide options:

```powershell
powershell -ExecutionPolicy Bypass -File .\Convert-PdfToJpeg.ps1 \
  -PdfPath "C:\Path\To\Your.pdf" \
  -Dpi 300 \
  -Quality 90 \
  -OutputFolder "C:\Path\To\jpg"
```

- **`-Dpi`**: Image resolution (higher = better quality, larger files). 300 is great for printing; 150 is fine for screen.
- **`-Quality`**: JPEG compression (1–100). 90 is a good balance.

## Requirements
- Windows 10 or 11
- Internet connection (only for the first run) to install:
  - **ImageMagick** and **Ghostscript** (the script installs them automatically via **winget**)
- If you see a message about **winget missing**:
  - Install Microsoft **App Installer** from the Microsoft Store (this adds winget), then run again

## Troubleshooting
- **Winget missing / installer error**: Install **App Installer** from Microsoft Store, then try again.
- **Execution policy blocked**: Use the command with `-ExecutionPolicy Bypass` (shown above).
- **No PDF chosen**: Run again and select a file when prompted.
- **Slow on first run**: It may be installing ImageMagick/Ghostscript — that’s normal.
- **SmartScreen warning**: Click **More info** → **Run anyway** (this is expected for small helper tools).
- **Admin approval prompt**: Click **Yes**. The installer needs it only to add the free tools.
 - **Window closes too fast / can’t read error**: Open the `last-run.log` file next to `Run-Me.bat` to see details.
 - **Using PowerShell 7 (`pwsh`)**: Prefer Windows PowerShell (`powershell.exe`) — the tool auto-restarts in STA mode to show the file picker.
 - **Ghostscript not found / install fails**: Try refreshing winget sources, then install manually:

```powershell
winget source update
winget install --id ArtifexSoftware.Ghostscript -e --accept-package-agreements --accept-source-agreements
# If that fails, try the alternate ID:
winget install --id Ghostscript.Ghostscript -e --accept-package-agreements --accept-source-agreements
```

## Privacy
Everything runs locally on your PC. Your PDF never leaves your computer.

---

Made simple with `Convert-PdfToJpeg.ps1`. Double‑click `Run-Me.bat` and you’re set!
