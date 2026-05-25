---
name: professional-doc-and-slides
description: Workflow for creating professional PDF documentation and HTML interactive slides using SVG diagrams.
---

# Professional Documentation & Presentation Slides

## Trigger
User asks for professional documentation (PDF) AND/OR HTML presentation slides with diagrams for any technical topic.

## Workflow

### Phase 1: Research & Content Extraction
1. Read all reference files the user points to (PDFs, MDs, etc.)
2. Extract key concepts, commands, architecture, and workflow steps
3. Identify what diagrams are needed (component diagrams, flow diagrams, automation workflows)

### Phase 2: SVG Diagram Creation (NO ASCII ART)
**Critical:** Never use ASCII art for diagrams. Always create proper SVG vector graphics.

1. **Manual SVG approach** (recommended): Write SVG XML manually with explicit x/y coordinates for every text element
2. **Key rules for clean SVG:**
   - Use `text-anchor="middle"` or `"start"` explicitly per text element
   - Never rely on `containerId`-based centering (causes text overlap in auto-generated SVGs)
   - Use viewBox="0 0 W H" with exact pixel dimensions
   - Color code components: purple (host/cli), blue (P-VOL), green (S-VOL/pool), amber (CoW/notes), red (delete/warn)
   - Always define arrow `<marker>` elements for flow diagrams
3. **ID prefixing for multi-SVG HTML:** When embedding multiple SVGs in one HTML file, prefix all marker IDs to avoid collisions:
   ```python
   svg = svg.replace('id="a-purple"', 'id="d1-a-purple"')
   svg = svg.replace('url(#a-purple)', 'url(#d1-a-purple)')
   ```
4. **Responsive SVG:** Replace fixed width/height with `width="100%"` and `height="auto"` while preserving viewBox

### Phase 3: Professional PDF Document

**Technology:** Python + `weasyprint` (not pandoc/wkhtmltopdf — often unavailable in WSL)

**Sections to include:**
1. Cover page (title, subtitle, version, date)
2. Table of Contents
3. Architecture / Overview (with SVG diagram)
4. Process Flow (with SVG diagram)
5. Implementation / Setup Guide
6. Command Reference & Troubleshooting
7. Official References (HPE docs, document IDs, URLs)

### Phase 4: HTML Presentation Slides

**Key Features:**
- Full-screen slide container (`width: 100vw; height: 100vh`)
- Navigation buttons (Prev/Next) fixed at bottom-right
- Keyboard shortcuts: Arrow Keys, Space, Home, End
- Touch swipe support
- Progress bar at bottom
- Professional styling (clean titles, accent bars, clean lists)

### Phase 5: File Cleanup
After both PDF and HTML slides are verified working:
- Remove old/duplicate files (files with ASCII art, auto-generated SVGs, intermediate HTMLs)
- Keep only: final PDF, final HTML slides, original .md sources, SVG diagram files, reference PDFs

## Pitfalls
- **DO NOT** use auto-generated SVG from Excalidraw JSON — text overlaps because of `containerId`
- **DO NOT** embed ASCII art diagrams in the final document
- **DO NOT** rely on pandoc/wkhtmltopdf in WSL — use weasyprint instead
- **DO NOT** forget to prefix SVG marker IDs when multiple SVGs share one HTML file
- **ALWAYS** verify text doesn't overlap by checking SVG coordinates manually
- **ALWAYS** include official document references with document IDs in the References section
- **ALWAYS** make the HTML presentation open in any browser without dependencies (no CDN, pure CSS/JS)

### Phase 6: Certificate, Signing & PDF Security
**Run once (per certificate):**
```bash
# 1. Generate RSA 2048 key + self-signed certificate
mkdir -p ~/.hermes/certs
openssl genrsa -out ~/.hermes/certs/angga_private.key 2048
openssl req -new -x509 -key ~/.hermes/certs/angga_private.key \
  -out ~/.hermes/certs/angga_cert.crt -days 1825 \
  -subj "/CN=Angga WISNU/OU=Personal branding/O=Not affiliated to any organization/L=DKI Jakarta/C=ID"

# 2. Export to PKCS#12 (.p12) — password "docaw2025" for script access
openssl pkcs12 -export -out ~/.hermes/certs/angga_signer.p12 \
  -inkey ~/.hermes/certs/angga_private.key \
  -in ~/.hermes/certs/angga_cert.crt -passout pass:docaw2025

# 3. Install dependencies (inside pdf_tools venv)
sudo apt install -y python3.14-venv
python3 -m venv ~/.hermes/venvs/pdf_tools
~/.hermes/venvs/pdf_tools/bin/pip install pyhanko pypdf cryptography
```

**The sign_pdf.py script** lives at `~/.hermes/scripts/sign_pdf.py`. Key behaviors:
- Signs PDF with certificate (pyhanko) + encrypts with AES-256 (pypdf)
- **File naming:** `YYYY.MM <Title as-is with spaces>-docaw<seq>.pdf`
  - Title capitalization preserved — not lowercased
  - Spaces kept, only filesystem-unsafe chars removed
- **Security model:**
  - `user_password=""` (empty) → anyone can open/read/print low-res **without password**
  - `owner_password="P455wordP@45sw.rd"` → full access: modify, copy, extract, assemble
  - Permissions: `UAP.PRINT | UAP.PRINT_TO_REPRESENTATION` (print only, no high-res)
- DocMDP `NO_CHANGES` locks the document after signing
- Metadata applied: Title, Author, Creator, Producer, Keywords, Comment
- 8-char alphanumeric sequence persisted at `~/.hermes/certs/.docaw_counter`

**Usage:**
```bash
~/.hermes/venvs/pdf_tools/bin/python3 ~/.hermes/scripts/sign_pdf.py \
  <input.pdf> \
  "HPE XP8 Storage Fast Snap Replication and Automation" \
  "HPE XP8,Fast Snap,Snapshot,RAID Manager,Automation" \
  [--html]   # if input is HTML (builds PDF with weasyprint first)
```
**Dependencies:** pyhanko, pypdf, cryptography (in `~/.hermes/venvs/pdf_tools`)
**Verify output:**
```python
import pypdf
r = pypdf.PdfReader("output.pdf")
print(r.is_encrypted)                # True
r.decrypt("P455wordP@45sw.rd")       # SUCCESS if correct
print(r.pages[0].extract_text()[:50])  # readable content
```

## Pitfalls
- **DO NOT** use auto-generated SVG from Excalidraw JSON — text overlaps because of `containerId`
- **DO NOT** embed ASCII art diagrams in the final document
- **DO NOT** rely on pandoc/wkhtmltopdf in WSL — use weasyprint instead
- **DO NOT** forget to prefix SVG marker IDs when multiple SVGs share one HTML file
- **DO NOT** swap user_pwd and owner_pwd — `user_pwd=""` gives open access, `owner_pwd` gates full access
- **ALWAYS** verify text doesn't overlap by checking SVG coordinates manually
- **ALWAYS** include official document references with document IDs in the References section
- **ALWAYS** make the HTML presentation open in any browser without dependencies (no CDN, pure CSS/JS)
- **ALWAYS** use the pdf_tools venv python when running sign_pdf.py — system python may lack the packages

## Verification
Before declaring done:
1. Open HTML slides in browser — test Prev/Next, keyboard, resize window
2. Open PDF — check no text overlap, clean page breaks, diagrams visible
3. Confirm all diagrams are SVG (not ASCII)
4. Confirm References section exists with document IDs
5. Verify signed PDF: opens without password, owner-pwd grants full access, signature visible in viewer
