# Phase 1: Production Reality Check (2026-05-26)

## TL;DR

- 🚨 **27 of 28 redirects NOT live.** Commit `5336f86` carrying the 26 GSC redirects was committed in this session but **never pushed to origin/main**. Only 1 of the 2 pre-existing redirects (`tile-floors-orlando`) is serving correctly. Google still sees the 26 URLs as 404.
- ⚠️ **Starting-state correction.** The audit brief references a "283-article contamination cohort with robotsNoIndex: true" — that cohort is from `~/seo-pipeline/` (prorepairguide + averagecostdata), NOT floridahomecosts. **Zero** .md files at `site-template/content/` have `robotsNoIndex: true`. The corpus here is fully indexed.
- ⚠️ **AdSense without CMP.** Page source carries `ca-pub-4688530569366595` and `adsbygoogle.js` but **no Google CMP / fundingchoices.js / consent script**. Acceptable for US-only traffic; non-compliant if any EU/UK traffic.
- ✅ Sitemap healthy (405 URLs), includes last night's cron articles, served from `https://floridahomecosts.com/sitemap.xml`.
- ✅ robots.txt clean (allow-all, sitemap referenced).

## 1.1 + 1.2 — Redirect verification (28 files, 27 NOT live)

Commit `5336f86 fix: 26 GSC 301 redirects from old URL paths` exists in local `main` but not in `origin/main`:
- `git log --oneline origin/main..main` → `5336f86` (one local-only commit)
- `git branch -r --contains 5336f86` → empty (no remote has it)
- `origin/main` head: `26c7e5e Add: cost to clean ac coils in Tampa 2026` (cron, 2026-05-26 04:06 UTC)
- Latest "Deploy Hugo Site" workflow run: `success` for `26c7e5e`, **none for `5336f86`** (because origin doesn't have it)

Live probe results:

| Source URL | src code | tgt code | Status |
|---|---|---|---|
| `/interior/cost-to-install-tile-floors-orlando-2026/` | 200 | 200 | ✅ live (pre-existing, commit 446fe3a) |
| `/interior/cost-to-install-hardwood-floors-miami-2026/` | 200 | n/a | ⚠️ serves but content article overrides redirect (Hugo conflict — `.md` exists at same path) |
| 26 other URLs (commit 5336f86) | **404** | n/a | ❌ not deployed |

**Risk of waiting:** tonight's cron (~23:45 local) will run `git add . && git commit && git push` — if my local main hasn't been reconciled by then, the cron either fails on non-fast-forward or rebases over `5336f86`. Either outcome jeopardizes the redirect files.

## 1.3 — Sitemap baseline check

| Metric | Value |
|---|---|
| Live sitemap URL count | 405 |
| Prior audit baseline | 405 |
| Δ since prior audit | 0 new / 0 removed |
| Last night's cron articles present? | ✅ yes (3/3 sampled, all live + indexed) |

The sitemap is at steady-state. The "405 baseline" already included last night's 5 cron articles.

## 1.4 — noindex verification (10 random articles)

10 random article URLs sampled across `/electrical/`, `/exterior/`, `/general/`, `/hurricane-protection/`, `/hvac/`, `/interior/`, `/major-systems/`, `/plumbing/`, `/pool/`, `/roofing/`.

**All 10 return HTTP 200, none have `<meta name="robots" content="noindex">` in served HTML.**

This is **expected**, not a propagation failure. Verification:
- Search across all 356 .md files: `grep -lE 'robotsNoIndex:\s*true|noindex:\s*true'` returns **0 files**
- `~/seo-pipeline/logs/contamination_audit.csv` contains 0 floridahomecosts references — that audit covered `prorepairguide` + `averagecostdata` only

**Conclusion:** the brief's mention of "the original 283-article contamination cohort" does not apply to floridahomecosts. The corpus here is fully indexed by Google with no noindex flags. **Starting-state claim in brief was stale — flagged per brief's instructions.**

## 1.5 — robots.txt + AdSense + CMP

robots.txt (live):

```
User-agent: *
Disallow:
Sitemap: https://floridahomecosts.com/sitemap.xml
```

- ✅ Googlebot not blocked (`Disallow:` is empty)
- ✅ Sitemap reference present
- ⚠️ No explicit `Disallow: /pooling/` etc. — phantom sections are not blocked at robots level. Acceptable since they now have static redirects locally (pending push) and don't exist as content. Could add as belt-and-braces but not urgent.

Homepage HTML inspection:

| Signal | Present? | Notes |
|---|---|---|
| AdSense pub ID `ca-pub-4688530569366595` | ✅ | embedded in script src |
| `pagead2.googlesyndication.com/pagead/js/adsbygoogle.js` | ✅ | loaded async |
| Google CMP / `fundingchoices.js` | ❌ | **NOT present** |
| `__gpp` / consent globals | ❌ | NOT present |
| `<link rel="canonical">` on homepage | ❌ | NOT present |
| `<meta name="robots">` on homepage | ❌ | NOT present |
| Homepage size | 19,593 bytes | reasonable |

**AdSense without CMP** is non-compliant if floridahomecosts.com receives EU/UK traffic — Google's AdSense policy requires a CMP for that geo. Self-assessed risk depends on traffic mix. If site is genuinely US-only (Florida-specific topic), the practical risk is small.

## Phase 1 ratings

- Redirects: **🚨 BROKEN** (1/28 live; 26 unpushed)
- Sitemap: ✅
- Indexability: ✅ (all content is indexed; no noindex anywhere)
- robots.txt: ✅
- AdSense: ⚠️ (no CMP; acceptable for US-only)
- Trust signals on homepage: ⚠️ (no canonical, no meta robots — minor)
