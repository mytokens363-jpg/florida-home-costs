# Phase 2: Content Corpus Audit (2026-05-26)

CSV detail at `logs/audit_phase2_corpus.csv` (one row per file).

## TL;DR

**Corpus is overwhelmingly clean. 98.3% (341/347) pass all quality checks.** No INDEXED_BUT_CONTAMINATED. No PLACEHOLDER_LEAK. No NOINDEX_* (because the corpus has zero noindex flags — see Phase 1.4).

## Bucket totals

| Bucket | Count | %    |
|---|---|---|
| CLEAN | 341 | 98.3% |
| SHORT_BODY | 3 | 0.9% |
| OTHER_DEFECT | 2 | 0.6% |
| MALFORMED_H1 | 1 | 0.3% |
| INDEXED_BUT_CONTAMINATED | **0** | — |
| PLACEHOLDER_LEAK | **0** | — |
| NOINDEX_CONTAMINATED | **0** | — |
| NOINDEX_BUT_CLEAN | **0** | — |
| **Total** | **347** | |

(The 9 difference from 356 baseline = 9 `_index.md` taxonomy stubs, intentionally skipped.)

## False-positive correction

First pass of the contamination matcher hit `electrical/cost-to-install-recessed-lighting-in-miami-2026.md` on the phrase `"i need to"` — but that phrase appeared inside the FAQ heading `### Do I need to upgrade my electrical panel?`. That's legitimate English, not chain-of-thought leakage.

Tightened the marker list to remove common-English false positives (`"let me"`, `"i need to"`, `"i will check"`) and kept only high-signal contamination phrases (`"thinking process"`, `"(wait,"`, `"<thinking>"`, `"here is the article"`, etc.). After tightening, 0 contamination hits across 347 files.

## Bucket × section breakdown

| section | CLEAN | MALFORMED_H1 | OTHER_DEFECT | SHORT_BODY |
|---|---|---|---|---|
| (root) | 0 | 1 | 0 | 3 |
| electrical | 25 | 0 | 0 | 0 |
| exterior | 57 | 0 | 0 | 0 |
| general | 10 | 0 | 0 | 0 |
| hurricane-protection | 39 | 0 | 1 | 0 |
| hvac | 32 | 0 | 0 | 0 |
| interior | 51 | 0 | 0 | 0 |
| major-systems | 32 | 0 | 0 | 0 |
| plumbing | 20 | 0 | 0 | 0 |
| pool | 26 | 0 | 0 | 0 |
| roofing | 49 | 0 | 1 | 0 |

No category has systemic quality issues — defects are scattered single occurrences.

## The 6 non-CLEAN files

| Path | Bucket | Words | Notes |
|---|---|---|---|
| `about.md` | SHORT_BODY | 420 | utility page, no FAQ expected |
| `privacy.md` | SHORT_BODY | 632 | utility page, no FAQ expected |
| `search.md` | SHORT_BODY | 0 | search-shortcode template — empty body intentional |
| `disclaimer.md` | MALFORMED_H1 | 755 | H1 is "Disclaimer" (single word) — heuristic false positive; acceptable |
| `hurricane-protection/cost-to-install-impact-windows-in-tampa-2026.md` | OTHER_DEFECT | 1742 | real article missing FAQ section |
| `roofing/cost-to-replace-roof-in-florida-2026.md` | OTHER_DEFECT | 872 | real article missing FAQ section |

**4 of 6 are non-issues** (utility pages + the Disclaimer H1 heuristic false positive).

**2 of 6 are real defects worth fixing:** two articles are missing the FAQ section that the rest of the corpus has. Easy fix — re-edit those two through the pipeline or add the FAQ manually. Not blocking.

## Quality characteristics across the 341 CLEAN files

Spot-checks during recon:
- H1s use natural "How Much Does It Cost to..." pattern (not the prorepairguide-style `Best X` defect)
- Frontmatter titles use "Cost To <Trade> In <City> 2026" (capitalization odd but not mangled)
- Word counts cluster 800-2500
- Each file has at least one H2 and a FAQ section
- Pricing references plausible Florida-specific numbers
- Categories/tags populated

## Phase 2 rating

**✅ GREEN.** Content corpus is clean. No leak, no contamination cohort lurking. The pipeline that generated these articles (not the same one as prorepairguide — see Phase 3) is producing usable content.
