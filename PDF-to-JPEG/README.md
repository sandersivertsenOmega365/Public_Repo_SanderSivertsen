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

## Privacy
Everything runs locally on your PC. Your PDF never leaves your computer.

---

Made simple with `Convert-PdfToJpeg.ps1`. Double‑click `Run-Me.bat` and you’re set!
