---
name: runtime-footer-model
description: >
  Show the actual backend model name (not the gateway routing name) in the CLI one-shot and TUI interactive footer.
  Custom prefix: "████░░░░░░ completed using [model]".
category: hermes-agent-dev
---

# Runtime Footer — Actual Model Display

## Purpose
Display the real backend model name used for each response, instead of the gateway
routing name (e.g., `wizz-all-providers`). Works in both CLI one-shot mode (inside
the response box) and the interactive TUI.

## What was changed

### 1. `agent/conversation_loop.py`
Track `_actual_model` from `response.model` (the API response object) and return
it in the result dict:

```python
# Near the top of process_conversation_loop()
_actual_model = None  # Track the actual backend model used

# Inside the try block, after successful API call:
_actual_model = getattr(response, "model", None)

# In the return dict (outside try block):
"model": _actual_model or agent.model,
```

**Key fix:** `_actual_model` assignment must be **outside** the `_invoke_hook("post_api_request", ...)` try/except block. If it's inside, silent exceptions prevent the assignment from executing.

### 2. `cli.py` — Close box (TUI + one-shot)
In the box-close section (~line 4513), the footer is built and printed **inside** the
response box with two blank lines before it:

```python
if footer:
    _cprint("")   # blank line
    _cprint("")   # blank line
    _cprint(f"{_STREAM_PAD}{footer}")
# Then the box border:
_cprint(f"{_ACCENT}╰{'─' * (w - 2)}╯{_RST}")
```

### 3. `gateway/runtime_footer.py`
Rewrote `build_footer_line()` to:
- **Add prefix** `████░░░░░░ completed using ` before the model name
- **Filter fields** — only `model` is rendered; provider, context_pct, cwd are excluded
- **Strip provider suffix** from model strings (e.g., `openrouter/model` → `model`)

Default fields: `("model",)` only.

## Config (`~/.hermes/<profile>/config.yaml`)
```yaml
display:
  runtime_footer:
    enabled: true
    fields: ["model"]   # only model — no provider/context/cwd
```

## How to verify
```bash
# CLI one-shot:
hermes --profile hpe "hi"
# Footer shows: ████░░░░░░ completed using <actual-model>

# Interactive TUI:
hermes --profile hpe
# Send a message — footer appears inside the response box
```

## Pitfalls
- **`_actual_model` silently not set:** The `_invoke_hook("post_api_request", ...)` call can raise silently, blocking code below it. Always place `_actual_model` assignment **outside** that try/except.
- **`response.model` varies by provider:** Some return `openrouter/anthropic/claude-3`, some return `gemma-3-flash-preview`. The footer code strips the provider prefix automatically.
- **Status bar prefix causes truncation:** Adding the "████░░░░░░ completed using " prefix directly to the TUI status bar (`_build_status_bar_text`) truncates to 26 chars. The status bar has hard width constraints — long prefixes get cut. Do NOT put the full prefix in the status bar. Instead, render the footer **inside the response box** (after two blank lines, before the box border `╰`).
- **Status bar vs response-box footer:** These are separate rendering systems. The status bar is a live-updating bottom bar. The response-box footer is printed once per response inside the box. This skill modifies only the response-box footer, NOT the status bar.
- **TUI and CLI share the same close-box code:** The box-close section in `cli.py` (~line 4513) handles both one-shot CLI and interactive TUI. Changes there apply to both modes.
