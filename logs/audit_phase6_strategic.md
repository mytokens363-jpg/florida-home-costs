# Phase 6: Strategic Readiness Synthesis — floridahomecosts.com

**Audit date:** 2026-05-26  
**Scope:** floridahomecosts.com (rivet-business pipeline)  
**Sources:** logs/audit_phase{1-5}*  

## Four-axis rating

| Axis | Rating | One-line |
|---|---|---|
| **Indexing health** | 🟡 YELLOW | Google trusts the domain; 26 promised redirects are not actually live (commit unpushed); 7 perfect duplicates between general/ and roofing/ create cannibalization. |
| **Content quality** | 🟡 YELLOW | Corpus is 98.3% clean (no contamination, no leak), but 95% of internal markdown links go to 404. The articles read well; the link graph is broken. |
| **Pipeline readiness** | 🟢 GREEN | Healthy nightly cadence (5/night, last 5 nights = 19 published / 1 error), Editor 7.7-9.2, SEO 8.0-9.2. Different pipeline from prorepairguide — does NOT share its defects. |
| **Trust signals** | 🟡 YELLOW | About page substantive, author bylined, Florida-specific signals deep, schema.org baseline OK. Missing: methodology page, contact page, multi-author bylines. |

## Indexing health — detail

- Sitemap: 405 URLs, matches baseline, includes last night's cron articles ✅
- robots.txt clean, googlebot allowed, sitemap referenced ✅
- 30/30 sampled articles have correct self-canonical ✅
- 28 redirect files on disk; **27 not live** because commit `5336f86` was committed locally but never pushed to `origin/main` (also creates a fast-forward risk for tonight's cron) 🚨
- 7 perfect-title duplicates between `/general/` and `/roofing/` from incomplete migration (commit `adfd802`) — Google sees both versions ⚠️
- 0 noindex tags across 356 .md files — the "283-article contamination cohort" from the audit brief is from `~/seo-pipeline/` (a different project), NOT floridahomecosts. **Starting-state claim in brief corrected.**
- AdSense without CMP — acceptable for US-only traffic, non-compliant if EU/UK traffic exists ⚠️

## Content quality — detail

- 347 article files audited; 341 (98.3%) pass all quality checks ✅
- 0 INDEXED_BUT_CONTAMINATED (one false positive on legitimate FAQ heading "Do I need to upgrade my electrical panel?", corrected)
- 0 PLACEHOLDER_LEAK (`[[LINK:]]` placeholders stripped by `build_hugo_frontmatter`)
- 2 articles with no FAQ section (real defect — `cost-to-install-impact-windows-in-tampa-2026.md`, `cost-to-replace-roof-in-florida-2026.md`)
- Spot-check on 5 articles: real prices, real Florida codes, plausible advice, no fabrication of business names ✅
- 🚨 **836 internal markdown links, 792 broken (94.7%)** — writer LLM hallucinates target slugs and even whole sections (`/landscaping/`, `/foundation/`, `/insurance/`, `/solar/`, `/smart-home/`, `/outdoor-living/`, etc.)

## Pipeline readiness — detail

- Pipeline at `~/.openclaw/workspace/rivet-business/night_shift.py`, **NOT** the same as `~/seo-pipeline/` (prorepairguide)
- Writer (Qwen3.5-35B-A3B-FP8 on 10.0.0.13) → Editor + SEO consensus (Qwen3.5-122B on 10.0.0.21) → publish
- File-based state (no SQLite); queue at `site-template/keyword-queue.md`
- 5 articles/night via launchd `com.rivet.night-shift` at 23:45 local
- Last 5 nights: 19 published / 1 error / 0 quarantined
- QA scores last 50: Editor 7.7-9.2 (median 8.5), SEO 8.0-9.2 (median 8.8) — calibrated band
- Queue: 71 PENDING, 2 IN_PROGRESS orphaned (known issue, manual flip-back needed)
- Topic format clean: `cost to <verb> <object> in <City> <Year>` — no naive-pluralization defect like prorepairguide

## Trust signals — detail

| Signal | State |
|---|---|
| About page | ✅ substantive, 22 KB, author cited |
| Methodology page | ❌ 404 |
| Author byline | ✅ on every article ("Marco Reyes") |
| Contact page | ❌ 404 |
| Privacy | ✅ |
| Disclaimer | ✅ |
| Terms | ❌ 404 |
| Pillar pages | ✅ all 10 sections live |
| Internal linking (template-generated) | ✅ Related Cost Guides, sidebar, footer |
| Internal linking (markdown-generated) | 🚨 broken (Phase 5 finding) |
| Schema.org | ✅ Article + Organization (missing BreadcrumbList + FAQPage) |
| Florida-specific verifiable signals | ✅✅ STRONG (HVHZ, NOA, FBC 2023, Florida Statute 489.126, City of Sunrise Building Dept, etc.) |
| Single-author byline at scale | ⚠️ Marco Reyes × 347 — content-farm tell |

## Recommended next move: (B) DRIP — but with a 24-hour cleanup window first

The site is structurally close to publish-ready, but **two issues should be resolved before more articles ship**:

1. **The 26 unpushed redirects.** Either push `5336f86` to `origin/main` (cron-collision risk if not done before 23:45), OR roll back and re-do via a controlled deploy after the bigger fixes.
2. **The 792 broken internal links** are the highest-quality-leverage fix on the site. Each new article will continue adding ~2-3 more broken links if the writer prompt isn't constrained.

These two are 1-2 days of focused work. After that, **resume the existing 5/night cadence** — pipeline is healthy, corpus is clean, trust signals are 70% there.

**DO NOT** scale up cadence (e.g., 10-30/night) until the link-graph fix is in and the methodology/contact pages are added.

**DO NOT** pause indefinitely — the corpus is too clean to abandon, and the publication is genuinely useful Florida content.

## Top 5 specific next actions (in order)

| # | Action | Effort | Impact |
|---|---|---|---|
| 1 | Push commit `5336f86` to `origin/main` so the 26 GSC redirects actually go live (before tonight's 23:45 cron creates a fast-forward conflict) | 5 min | High — fixes 26 GSC-visible 404s |
| 2 | Delete the 7 `/general/*` duplicates with `/roofing/*` equivalents; add aliases on the `/roofing/` versions to old `/general/` URLs | 30 min | Medium — kills cannibalization, preserves traffic |
| 3 | Build a Python script to rewrite/strip the 792 broken markdown internal links across the corpus. Heuristic: if target slug doesn't exist but a stem-similar one does, remap; otherwise drop the `(url)` and keep plain text. | 2-3 hours | **Very high** — the single biggest content quality lift available |
| 4 | Constrain the writer prompt to either (a) skip "Related guides" section, or (b) consume a "known slugs" file at runtime and only emit links to those | 1-2 hours | High — stops new broken-link creation |
| 5 | Add `/methodology/` and `/contact/` pages; add `FAQPage` + `BreadcrumbList` schema to the Hugo template | 2-3 hours | Medium-high — closes the largest E-E-A-T gap |

## Open questions for the user

1. **Push `5336f86` tonight, or hold?** If held, you'll need to manually reconcile when the 23:45 cron tries to push and finds a non-fast-forward.
2. **The 290 `approved-hold` articles in `~/seo-pipeline/pipeline.db`** — that's prorepairguide, not this site. Confirming you treat that as a separate decision.
3. **Single-author "Marco Reyes" — acceptable as a stylistic choice, or do you want to introduce 2-3 additional bylines?** This affects future writer-prompt design.
4. **Methodology page** — do you have a real methodology (cost-data sources) that can be documented, or would a generic "we research cost data from contractor surveys + permit fee schedules" suffice?
5. **`/general/` section future** — keep it as a catch-all for cross-category content (current state), or migrate everything out and retire the section?

## Audit deliverables

| File | Contents |
|---|---|
| `logs/audit_phase1_production.md` | Production reality check |
| `logs/audit_phase2_corpus.csv` + `logs/audit_phase2_corpus.md` | 347 .md files bucketed |
| `logs/audit_phase3_pipeline.md` | Pipeline scope check |
| `logs/audit_phase4_trust_signals.md` | E-E-A-T audit |
| `logs/audit_phase5_technical.md` | Technical SEO |
| `logs/audit_phase6_strategic.md` | This file |
