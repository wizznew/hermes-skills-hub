---
name: wizz-news-daily
description: Fetch today's top news headlines and summaries (Indonesia & world) in Indonesian language, max 10 articles with 3-6 paragraphs each, include source provider.
---

# Daily News Summary — wizz-news-daily

## Purpose
Fetch top news headlines and summaries for today across Indonesia and world topics. Return max 10 most important stories in Indonesian language, each with 3-6 paragraph summary and news provider/source.

## How it works

### Step 1 — Web Search
Run two parallel web searches:

```
# Indonesia news
web_search(query="berita penting hari ini [tanggal] Indonesia politik ekonomi")
web_search(query="breaking news Indonesia [tanggal]")

# World news
web_search(query="top news today [tanggal] world")
web_search(query="breaking news [tanggal] Trump Iran Ukraine")
```

Use current date in format: "6 Juni 2026" (Indonesian) and "June 6, 2026" (English).

### Step 2 — Web Extract (Optional)
For important stories, extract full content via `web_extract(urls=[...])` to get accurate paragraph-level summaries.

### Step 3 — Compile Output
Format each news item as:

| Element | Format |
|---|---|
| Headline | Bold title + provider in parentheses |
| Summary | 3-6 paragraphs in Indonesian |
| Provider | Domain from source URL (e.g., *detik.com*, *bbc.com*) |
| Language | Full Indonesian |
| Order | Indonesia news first, then world news |

### Output Format (Table)
```
| No | Headline + Provider | Ringkasan (3-6 paragraf) |
|---|---|---|
| 1 | **[Headline] – *provider*** | [Paragraph 1] [Paragraph 2] ... [Paragraph N] |
```

### Formatting Rules
- Headline: bold title, provider in parentheses italic
- Paragraphs: 3-6 per article, Indonesian language
- Provider label: extracted from URL domain (e.g., *detik.com*, *reuters.com*)
- Total articles: max 10
- Mix: Indonesia + world news combined, Indonesia listed first
- Table must have 3 columns: No | Headline | Summary

## Example

| No | Headline + Provider | Ringkasan |
|---|---|---|
| 1 | **Judul Berita Utama – *detik.com*** | Paragraf pertama... Paragraf kedua... Paragraf ketiga... |

## Pitfalls
- **Language**: Always write summaries in Indonesian, even for world news
- **Provider**: Extract from URL domain, not title
- **Length**: Each summary must be 3-6 paragraphs, no more, no less
- **Date**: Always use current date in searches and headlines