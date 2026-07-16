# Phase 5: Technical SEO Health — 2026-05-26

## TL;DR

**Two showstoppers, both upstream of the templates:**
1. 🚨 **95% of internal markdown links are broken** (792 of 836) — writer LLM hallucinates target slugs, pointing to URLs and even whole sections that don't exist (`/solar/`, `/landscaping/`, `/foundation/`, `/insurance/`, `/smart-home/`, etc.)
2. 🚨 **7 article pairs have IDENTICAL titles** between `/general/` and `/roofing/` — the migration in commit `adfd802` ("move 4 misclassified roofing articles from general/ to roofing/") *copied* without deleting the originals, creating perfect duplicate content.

Everything else is healthy: speed excellent, mobile viewport correct, canonicals correct, aliases inventory minimal but expected.

## 5.1 — Page speed ✅ EXCELLENT

3 URLs sampled (homepage + 2 articles). All sub-200ms total time:

| URL | TTFB | Total |
|---|---|---|
| `/` (home) | 0.150s | 0.160s |
| `/roofing/cost-to-replace-roof-in-sunrise-2026/` | 0.124s | 0.132s |
| `/hvac/cost-to-clean-ac-coils-in-tampa-2026/` | 0.112s | 0.121s |

GitHub Pages + Cloudflare Pages caching is working as expected.

## 5.2 — Mobile viewport ✅

```html
<meta name=viewport content="width=device-width,initial-scale=1">
```

Present in the rendered article. Theme template `baseof.html:5` sets it for all pages.

## 5.3 — Canonical tags ✅ (30/30 correct)

Initially flagged one article with canonical = `/404.html` — turned out to be a self-inflicted false alarm (I sampled a URL not in the sitemap; the 404 page itself has `canonical=/404.html` which is fine).

Re-ran the check against 30 random URLs sourced from `/sitemap.xml`:

```
self=30, mismatch=0, missing=0 / total=30
```

Hugo template `baseof.html:10` correctly emits `<link rel="canonical" href="{{ .Permalink }}">` for every page.

## 5.4 — Duplicate content 🚨

### Perfect title duplicates (7 article pairs)

| Title | Files |
|---|---|
| Cost To Install Metal Roof In Fort Lauderdale 2026 | `general/...` AND `roofing/...` |
| Cost To Repair Roof In Florida 2026 | `general/...` AND `roofing/...` |
| Cost To Repair Roof In Orlando 2026 | `general/...` AND `roofing/...` |
| Cost To Replace Roof In Fort Lauderdale 2026 | `general/...` AND `roofing/...` |
| Cost To Replace Roof In Miami 2026 | `general/...` AND `roofing/...` |
| Cost To Replace Roof In Orlando 2026 | `general/...` AND `roofing/...` |
| Cost To Replace Tile Roof In Florida 2026 | `general/...` AND `roofing/...` |

**Root cause:** commit `adfd802 fix: move 4 misclassified roofing articles from general/ to roofing/` copied the files into `roofing/` but **did not delete from `general/`**. Result: 14 actual `.md` files (7 pairs) ranking-cannibalizing each other.

Likely also Google-confusing on first crawl since each pair appears in the sitemap with different URLs but identical titles and substantially identical bodies.

### Near-duplicate by first-200-words

20+ pairs with similarity ≥0.85 (search stopped at 20). Top pairs:

| Sim | Pair |
|---|---|
| 1.00 | `general/cost-to-replace-roof-fort-lauderdale-2026.md` vs `roofing/cost-to-replace-roof-in-fort-lauderdale-2026.md` |
| 1.00 | `general/cost-to-replace-roof-in-fort-lauderdale-2026.md` vs `roofing/cost-to-replace-roof-in-fort-lauderdale-2026.md` |
| 0.96 | `general/cost-to-replace-roof-in-miami-2026.md` vs `roofing/cost-to-replace-tile-roof-in-miami-2026.md` |
| 0.93 | `general/cost-to-replace-roof-in-miami-2026.md` vs `roofing/cost-to-replace-roof-in-coral-gables-2026.md` |
| 0.92-0.93 | Multiple `roofing/cost-to-replace-roof-in-<city>-2026.md` pairs |

The 1.00 pairs are the same content under two URLs (the migration leftovers). The 0.85-0.95 pairs are city variants of the same trade with templated openers — that's inherent to the city-by-city expansion strategy and not really fixable without rewriting the template to vary the opener more.

## 5.5 — Broken internal links 🚨🚨

**Headline:** 836 internal markdown links across 343 articles. **792 (94.7%) are broken.** Average article has ~2.3 broken internal links.

The writer LLM is hallucinating both target slugs AND entire sections. Breakdown of broken-link targets by section:

| Target section | Broken count | Section exists? |
|---|---|---|
| hurricane-protection | 178 | ✅ yes (but with slug-mangled targets) |
| interior | 102 | ✅ yes |
| roofing | 88 | ✅ yes |
| hvac | 85 | ✅ yes |
| exterior | 83 | ✅ yes |
| plumbing | 53 | ✅ yes |
| major-systems | 51 | ✅ yes |
| pool | 48 | ✅ yes |
| electrical | 41 | ✅ yes |
| `?` (no section) | 11 | n/a |
| landscaping | 9 | ❌ **fake section** |
| pooling | 9 | ❌ **fake section** (the `/pooling/` you flagged previously) |
| home-maintenance | 5 | ❌ **fake section** |
| insurance | 3 | ❌ **fake section** |
| solar | 3 | ❌ **fake section** |
| foundation | 3 | ❌ **fake section** |
| general | 3 | ✅ yes |
| kitchen | 3 | ❌ **fake section** |
| energy-efficiency | 2 | ❌ **fake section** |
| smart-home / irrigation / permitting / windows / garage / energy / renovation / flooring / permits / structural / water-heater / outdoor-living | 1 each | ❌ **all fake sections** |

**Two classes of broken links:**

**Class A (~700):** Target section exists but slug doesn't. Examples:
- `[...](/electrical/cost-to-install-smart-thermostat-florida-2026)` — no such article
- `[...](/electrical/cost-to-install-ceiling-lights-miami-2026)` — no such article (likely was meant to be `ceiling-fan-...`)
- `[...](/roofing/cost-to-replace-roof-miami-2026)` — slug missing `in-` (real article is at `cost-to-replace-roof-in-miami-2026`)

**Class B (~80):** Whole fake sections. Same set of phantom sections that show up in your GSC 404 report — `/pooling/`, `/foundation/`, `/insurance/`, `/solar/`, `/home-maintenance/`, `/outdoor-living/`, `/landscaping/`, etc. **This is the writer's contribution to the same problem we already mitigated with static redirects.** Each broken link in an article is a 404 your own site is generating for itself.

This is the most severe defect surfaced in the audit. Impact:
- Google's link analysis sees ~700 broken internal links → site looks abandoned/spammy
- Users clicking "Related guides" hit 404 pages on most articles
- Crawl budget wastes on dead URLs
- Trust signal damage compounds the missing-methodology + single-author issues

## 5.6 — `aliases:` inventory

5 articles have `aliases:` front-matter entries (matches the GSC redirect investigation earlier). Distinct alias URLs:

```
/electrical/cost-to-install-ev-charger-miami-2026/        → ev-charger-in-miami
/electrical/cost-to-install-home-generators-miami-2026/   → whole-house-generator-in-miami
/hurricane-protection/cost-to-install-impact-windows-tampa-2026/ → impact-windows-in-tampa
/interior/cost-to-paint-interior-walls-fort-lauderdale-2026/ → paint-interior-of-house-in-fort-lauderdale
/posts/cost-to-replace-roof-in-florida-2026/              → roof-in-florida
```

**Only 5 aliases for 14+ historical renames** (per commit log: `c0ba95b` "double-2026 fix", `adfd802` "general→roofing move", `93f1622` "add slug field for correct permalink", `446fe3a` "add 301 redirects"). Most historical URL changes were patched via static-HTML redirects in `site-template/static/`, not via Hugo aliases — but that approach requires the static redirect to actually be deployed (see Phase 1 — 27 of 28 not live).

## 5.7 — Pre-commit hook readiness ✅ (does NOT exist yet, as expected)

`ls .git/hooks/pre-commit*` → only the default `.sample` files, no custom hook.

The rename-without-alias pre-commit hook discussed in earlier sessions has not been built. This is the right defer — fixing the existing 792 broken links is higher priority than preventing future renames-without-aliases.

## Phase 5 ratings per item

| Item | Rating |
|---|---|
| Speed | ✅ |
| Mobile viewport | ✅ |
| Canonical tags | ✅ |
| Duplicate content (general/ ↔ roofing/) | 🚨 7 perfect-title duplicates |
| Broken internal links | 🚨🚨 792/836 (94.7%) broken |
| Aliases coverage | ⚠️ Only 5 entries for ~15 historical URL changes |
| Pre-commit hook | ✅ Not yet (correctly deferred) |

**Phase 5 verdict: 🚨 RED.** Two critical issues (broken internal links + duplicate content) and one moderate (alias coverage). Speed/canonical/mobile are all green. The fix scope is bounded but non-trivial.

## Recommended fixes in priority order

1. **Fix the broken-internal-links problem at the writer-prompt level.** Constrain the writer to either (a) skip the "Related guides" section entirely, or (b) be given a list of valid slugs from the queue's PUBLISHED set and only emit links to those. Highest impact per hour.
2. **Cleanup script for the 792 existing broken links** — convert markdown link to plain text (drop the `(url)` part) OR remap to a valid alternate based on Levenshtein/slug-stem matching. Reusable Python script, similar to the pluralization cleanup from earlier.
3. **Delete the 7 `/general/` duplicates** that have a corresponding `/roofing/` version — add aliases on the `/roofing/` versions pointing to the old `/general/` URL so Google's existing index doesn't 404.
4. **Add aliases on the 5 other historically-renamed articles** — this is forward-looking; the 26 static redirects (once pushed) cover the GSC-visible 404s.
