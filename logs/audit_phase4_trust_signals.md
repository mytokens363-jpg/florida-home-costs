# Phase 4: Trust Signal Audit (E-E-A-T) — 2026-05-26

## TL;DR

**Mostly GREEN.** Strong author attribution, substantive About page, deep Florida-specific signals throughout the corpus, schema.org markup present, working pillar pages, decent internal linking (template-generated). Two real gaps: **no methodology/sources page** and **no contact page**. One structural concern: single-author byline across 347 articles (synthetic persona at scale).

## 4.1 — About page ✅

URL: `https://floridahomecosts.com/about/` → 200, 22 KB

Substantive content. Sample (first 1200 chars):

> "Florida Home Costs is a home improvement cost guide built specifically for Florida homeowners. Every article on this site covers one service in one location with real pricing, local building code requirements, and practical contractor hiring advice. […] National home improvement sites give you national averages. That's not helpful when you live in a state with the High Velocity Hurricane Zone, the strictest building codes in the country, an insurance market in crisis, and contractor labor rates 15–20% above the national average."

Author cited: Marco Reyes, Florida Home Improvement Specialist. Updated 2026-04-05. 2-min read.

## 4.2 — Methodology page ❌

| URL | Status |
|---|---|
| `/methodology/` | 404 |
| `/how-we-research/` | 404 |
| `/our-data/` | 404 |
| `/sources/` | 404 |

**No documented methodology.** This is the biggest single E-E-A-T gap. Google's Helpful Content classifier explicitly weighs "how the content was made and sources cited" — having a documented methodology page would be one of the highest-ROI additions to the site.

## 4.3 — Author attribution ✅

5 random articles sampled (across `/electrical/`, `/interior/`, `/major-systems/`, `/roofing/`). Every article has:

```html
<div class=author-byline>
  Written by <strong>Marco Reyes</strong>, Florida Home Improvement Specialist
</div>
```

Bottom-of-article author bio block:

```
Marco Reyes — Florida Home Improvement Specialist
Marco has spent over 12 years in Florida's home improvement industry, working with
contractors across Miami-Dade, Broward, and Palm Beach counties. He specializes in
hurricane protection, roofing, and Florida Building Code compliance. His cost guides
are based on real contractor pricing data and hands-on project experience in the
South Florida market.
```

Author avatar image: `/images/authors/marco-reyes.jpg`.

⚠️ **Risk:** single author for all 347 articles. Google's quality classifier looks at author breadth as a credibility signal. A real publisher generally has multiple bylined writers with topical specialties. One-persona-for-everything is a content-farm tell. Strongest mitigation: add 2-3 additional bylines covering different domains (e.g., a roofing specialist, an insurance specialist, a general remodel writer).

## 4.4 — Contact information ❌

| URL | Status |
|---|---|
| `/contact/` | 404 |
| `/terms/` | 404 |
| `/legal/` | 404 |

No contact page. No email/form/address. Hurts E-E-A-T and is a soft AdSense compliance issue.

## 4.5 — Privacy + Disclaimer ✅ partial

- ✅ `/privacy/` 200
- ✅ `/disclaimer/` 200 (linked from footer)
- ❌ `/terms/` 404

Privacy + Disclaimer cover the AdSense baseline. Terms of Service is missing but typically not required for AdSense if Privacy covers data handling.

## 4.6 — Pillar pages / topical clustering ✅

All 10 category pages return 200:

```
200  /electrical/        200  /interior/
200  /exterior/          200  /major-systems/
200  /general/           200  /plumbing/
200  /hurricane-protection/   200  /pool/
200  /hvac/              200  /roofing/
```

Acts as hub for each topic cluster. Category landing pages aggregate the long-tail cost guides.

## 4.7 — Internal linking ✅ (mostly) / ⚠️ (markdown links broken)

**Per-article internal-link inventory** (rendered HTML, not raw markdown):

| Source | Count per article | State |
|---|---|---|
| Markdown "Related guides" section (3 links) | 3 | ❌ ALL 3 are 404 — writer hallucinates target URLs |
| Hugo template "Related Cost Guides" (3 cards) | 3 | ✅ correct slugs, 200 targets |
| Sidebar "Popular Guides" (5 links) | 5 | ✅ working |
| Footer categories (9 links) | 9 | ✅ working |
| TOC anchor links (within page) | ~10 | ✅ working |
| Breadcrumbs | 1-2 | ✅ working |

**Net result:** ~20 internal `<a>` tags per article, of which ~17 work and 3 point to 404s (the markdown-source "Related guides" section). Working links are template-generated; broken links are LLM-hallucinated.

Sampled broken targets (from `cost-to-replace-roof-in-sunrise-2026.md`):
- `/hurricane-protection/cost-to-install-impact-windows-sunrise-2026/` → 404
- `/hurricane-protection/cost-to-install-hurricane-shutters-broward-2026/` → 404
- `/roofing/cost-to-replace-roof-fort-lauderdale-2026/` → 404 (real article is at `…-roof-fort-lauderdale-2026/` without `-replace-`; slug-mangle)

This is a known fixable issue: writer should be constrained to only emit related-guide URLs that exist in the queue/published set.

## 4.8 — Schema.org structured data ✅

Sampled article has 1 `<script type="application/ld+json">` block with:
- `"@type": "Article"`
- `"@type": "Organization"`

Adequate baseline. **Missing but valuable:** `BreadcrumbList` (the breadcrumb HTML is rendered but no corresponding schema), `FAQPage` (every article has a FAQ section but no `Question`/`Answer` schema). Both are low-effort wins.

## 4.9 — Florida-specific verifiable signals ✅ STRONG

Sampled article (`cost-to-replace-roof-in-sunrise-2026/`) references:

| Signal | Count |
|---|---|
| `Broward County` | 5 |
| `Building Department` | 3 |
| `HVHZ` (High Velocity Hurricane Zone) | 2 |
| `Florida Statute` (489.126 — contractor deposit rules) | 1 |
| `Miami-Dade NOA` | 1 |
| `FBC` / `Florida Building Code 8th Edition` | mentioned |
| `MyFloridaLicense.com` (real CSLB equivalent) | mentioned + linked |
| `City of Sunrise Building Department` | named |
| `My Safe Florida Home` grant program (real, up to $10K) | mentioned |
| `Wind mitigation discounts 15–45%` (real range) | mentioned |

Per the About page: HVHZ, NOA, secondary water barrier all referenced. Citizens Insurance mentioned in other articles. **The site demonstrates genuine Florida-specific knowledge, not generic AI cost-guide language.** This is the strongest single trust signal on the site.

## Phase 4 ratings per item

| Signal | Rating |
|---|---|
| About page | ✅ |
| Methodology page | ❌ |
| Author attribution | ✅ (with single-author caveat) |
| Contact info | ❌ |
| Privacy / Terms | ✅ partial (no Terms) |
| Pillar pages | ✅ |
| Internal linking | ✅ (with 3 broken markdown links/article) |
| Schema.org | ✅ baseline (Article + Org) |
| Florida-specificity | ✅ STRONG |

**Phase 4 verdict: YELLOW → GREEN if methodology + contact pages added + broken markdown link sources cleaned up.** The corpus and Florida-domain credibility are strong; the structural pages just need filling in.

## Recommended quick wins (in order of ROI)

1. **Add `/methodology/`** — 1-2 page explaining: data sources (contractor surveys, Bureau of Labor Statistics for labor rates, Florida Permit fee schedules), update cadence, who reviews. Highest E-E-A-T uplift per hour of work.
2. **Add `/contact/`** — email + brief "we welcome corrections" message. Low effort, signals "real publisher."
3. **Fix the writer's "Related guides" hallucination** — constrain it to pick from existing slugs (queue's PUBLISHED list). Removes 3 dead links per article.
4. **Add 2-3 additional authors** with topical specialties (roofing/insurance/remodel). Removes the single-persona signal.
5. **Add `FAQPage` + `BreadcrumbList` JSON-LD** — every article already has a FAQ + breadcrumb HTML; adding the schema is a Hugo template change of ~10 lines.
