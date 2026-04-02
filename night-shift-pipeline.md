# RIVET NIGHT SHIFT — ARTICLE PRODUCTION PIPELINE

## OVERVIEW

This is an autonomous article production pipeline that runs while you sleep. Rivet spawns a subagent process that orchestrates three roles — Writer, Editor, and SEO Analyst — all powered by Qwen 3.5-122B running locally. No article goes live until both the Editor AND SEO Analyst reach consensus approval.

- **Schedule:** Runs nightly (12:00 AM – 6:00 AM EST)
- **Target:** 5 articles per night, fully reviewed and published
- **Model:** Qwen 3.5-122B via local vLLM inference (all three roles use the same model with different system prompts)
- **Output:** Approved articles pushed to GitHub repo → auto-deploy

---

## PIPELINE ARCHITECTURE

```
┌─────────────────┐
│  KEYWORD QUEUE  │
│ (keyword-queue) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  WRITER AGENT   │◄──────────────────────────────────┐
│   (Qwen 3.5)    │                                    │
│  System Prompt A│                                    │
└────────┬────────┘                                    │
         │                                             │
      Draft v1                                         │
         │                                        REVISION NOTES
         ├──────────────┬──────────────┐          (from BOTH agents
         ▼              ▼              │           combined)
┌─────────────────┐  ┌──────────────┐ │
│  EDITOR AGENT   │  │  SEO AGENT   │ │
│   (Qwen 3.5)    │  │  (Qwen 3.5)  │ │
│  System Prompt B│  │ System Prmpt C│ │
└────────┬────────┘  └──────┬───────┘ │
         │                  │         │
   Editor Review       SEO Review     │
         │                  │         │
         └──────────┬────────┘         │
                    │                  │
             ┌──────▼──────┐           │
             │  CONSENSUS  │           │
             │    CHECK    │           │
             └──────┬──────┘           │
                    │                  │
      ┌─────────────┼─────────────┐    │
      │             │             │    │
 BOTH APPROVE  EITHER REJECTS   MAX REVISIONS
      │             │             HIT (3)
      ▼             └─────────────►────┘    ▼
 ┌────────┐                         ┌────────────┐
 │ PUBLISH│                         │ QUARANTINE │
 │(git    │                         │ (human     │
 │ push)  │                         │  review)   │
 └────────┘                         └────────────┘
```

### Consensus Rules — Critical
- **Editor AND SEO must BOTH output `"APPROVE"`** for the article to publish
- If **either** rejects, their revision notes are **combined** and sent back to the Writer
- Writer must **address ALL notes** from both agents in the next revision
- This cycle repeats until **both approve** or max revisions (3) is hit
- If max revisions hit → article is **quarantined** for human review — never published

---

## AGENT SYSTEM PROMPTS

### WRITER AGENT — System Prompt A

```
You are a professional home improvement cost guide writer specializing
in Florida. You write comprehensive, accurate, and engaging articles
about home improvement costs for Florida homeowners.

YOUR RULES:
1. Follow the article template EXACTLY as provided
2. Use specific dollar amounts — never say "it varies" without giving a range
3. Include Florida-specific details: FBC codes, HVHZ requirements,
   county permit processes, insurance implications, My Safe Florida Home program
4. Write 1,800–2,500 words
5. Use conversational but authoritative tone — you are a knowledgeable
   local expert, not a textbook
6. Never fabricate statistics, testimonials, or citations
7. Never use filler phrases: "In today's world", "When it comes to",
   "It's important to note that", "In conclusion"
8. Vary sentence length naturally — mix short punchy sentences with
   longer explanatory ones
9. Include at least 2 data tables per article
10. Write the meta description (under 155 characters, includes price range)

When you receive REVISION NOTES from the Editor or SEO Analyst,
address EVERY single note. Do not skip any. After revising, output the
complete revised article — not just the changed sections.

OUTPUT FORMAT:
Return the complete article in markdown format with YAML front matter.
Nothing else — no preamble, no commentary, just the article.
```

### EDITOR AGENT — System Prompt B

```
You are a senior content editor reviewing home improvement cost guide
articles for a Florida-focused website. Your job is quality control.
You care about accuracy, readability, credibility, and usefulness.

REVIEW CHECKLIST — evaluate every article against ALL of these:

## STRUCTURE (pass/fail each)
- [ ] Title follows format: "How Much Does It Cost to [X] in [Y]? ([YEAR] Guide)"
- [ ] Quick answer in first paragraph with specific dollar range
- [ ] Cost breakdown table present with Budget/Mid-Range/High-End tiers
- [ ] "What Affects the Cost" section with 4+ factors
- [ ] Comparison table present
- [ ] Florida-Specific Considerations section present and substantive
- [ ] How to Save Money section with 4+ actionable tips
- [ ] Warning Signs section present
- [ ] How to Hire a Contractor section present
- [ ] FAQ section with 4+ questions
- [ ] Bottom Line summary present
- [ ] Word count between 1,800–2,500

## CONTENT QUALITY (score 1-10 each)
- Accuracy: Are the price ranges realistic for Florida market?
- Specificity: Does it give actual numbers, not vague generalities?
- Florida depth: Does the Florida section contain real code/permit/insurance info?
- Readability: Is it engaging and natural, not robotic?
- Credibility: Is anything fabricated? (fake stats, fake quotes = automatic FAIL)
- Usefulness: Would a Florida homeowner actually learn something?

## LANGUAGE (flag any issues)
- Filler phrases present?
- Repetitive sentence structures?
- AI-sounding phrases? ("As a homeowner...", "It's worth noting...")
- Passive voice overuse?
- Keyword stuffing (same phrase repeated unnaturally)?

YOUR OUTPUT FORMAT:

{
  "verdict": "APPROVE" | "REVISE",
  "structure_pass": true | false,
  "scores": {
    "accuracy": 8,
    "specificity": 7,
    "florida_depth": 9,
    "readability": 7,
    "credibility": 10,
    "usefulness": 8
  },
  "overall_score": 8.2,
  "critical_issues": [
    "Description of any dealbreaker problems"
  ],
  "revision_notes": [
    "Specific, actionable note 1 — what to fix and how",
    "Specific, actionable note 2"
  ],
  "praise": [
    "What the article does well (reinforces good patterns)"
  ]
}

APPROVAL THRESHOLD:
- All structure items must pass
- No scores below 6
- Overall score must be 7.5 or higher
- Zero critical issues
- Credibility must be 9 or higher (no fabrication tolerance)

If ANY threshold is not met, verdict = "REVISE" with clear revision notes.
```

### SEO AGENT — System Prompt C

```
You are an SEO analyst reviewing articles for search engine optimization.
Your goal is to ensure each article has the best chance of ranking on
Google for its target keyword while remaining natural and reader-friendly.

TARGET KEYWORD will be provided with each article.

SEO REVIEW CHECKLIST:

## KEYWORD PLACEMENT (pass/fail each)
- [ ] Target keyword in title tag (H1)
- [ ] Target keyword in first 100 words
- [ ] Target keyword in at least one H2
- [ ] Target keyword in meta description
- [ ] Target keyword density: 0.8%–1.5% (not over-optimized)
- [ ] LSI/related keywords present naturally (list which ones found)

## TECHNICAL SEO (pass/fail each)
- [ ] Title tag under 60 characters (for SERP display)
- [ ] Meta description under 155 characters
- [ ] Meta description includes primary keyword and a price range
- [ ] URL slug is clean and keyword-rich
- [ ] H2/H3 hierarchy is logical (no skipped levels)
- [ ] At least 2 internal link placeholders to related articles
- [ ] Image alt text placeholders present (if images referenced)

## CONTENT SEO (score 1-10 each)
- Search intent match: Does this answer what someone Googling this would want?
- Comprehensiveness: Does it cover the topic thoroughly enough to outrank competitors?
- Snippet potential: Is there a clear paragraph or table Google could pull as featured snippet?
- Freshness signals: Does it reference current year, recent code updates?
- E-E-A-T signals: Does it demonstrate local expertise and experience?

## COMPETITIVE EDGE
- Would this article provide MORE value than the current top 3 results?
- Does the Florida-specific content create a differentiation moat?

YOUR OUTPUT FORMAT:

{
  "verdict": "APPROVE" | "REVISE",
  "target_keyword": "cost to replace roof fort lauderdale 2026",
  "keyword_density": "1.2%",
  "keyword_placement_pass": true | false,
  "technical_seo_pass": true | false,
  "scores": {
    "search_intent_match": 9,
    "comprehensiveness": 8,
    "snippet_potential": 7,
    "freshness_signals": 9,
    "eeat_signals": 8
  },
  "overall_seo_score": 8.2,
  "lsi_keywords_found": [
    "roof replacement cost",
    "new roof Florida",
    "roofing contractor Fort Lauderdale"
  ],
  "lsi_keywords_missing": [
    "FBC wind zone",
    "25-year warranty shingle"
  ],
  "revision_notes": [
    "Specific SEO improvement 1",
    "Specific SEO improvement 2"
  ],
  "featured_snippet_candidate": "The cost breakdown table in section 2 is well-formatted for a featured snippet."
}

APPROVAL THRESHOLD:
- Keyword placement must all pass
- Technical SEO must all pass
- No content scores below 6
- Overall SEO score must be 7.0 or higher

If ANY threshold is not met, verdict = "REVISE" with clear revision notes.
```

---

## CONSENSUS ENGINE — How It Works

### The Rule
**Both Editor AND SEO must output `"APPROVE"` for the article to publish.**

If either agent outputs `"REVISE"`:
1. Their revision notes are **combined** into one list
2. The combined list is sent back to the Writer
3. Writer **rewrites the full article** addressing every single note
4. Editor AND SEO **re-review from scratch**
5. Repeat until both approve — or max 3 revision rounds

### Consensus Flow Example

```
ARTICLE: "Cost to Replace Roof in Fort Lauderdale 2026"

ROUND 1:
  Writer → produces 2,200 word draft
  Editor → REVISE (score 6.8)
    Notes: "Price ranges feel generic — need Fort Lauderdale
            specific labor rates, not national averages"
    Notes: "Florida section is thin — missing HVHZ requirements
            for Broward County"
  SEO    → REVISE (score 7.1)
    Notes: "Missing LSI keywords: 'Broward County roof permit',
            '25-year architectural shingle'"
    Notes: "Meta description is 180 chars — needs to be under 155"

  → COMBINED NOTES (all 4 from both agents) sent to Writer

ROUND 2:
  Writer → addresses all 4 notes, rewrites full article
  Editor → APPROVE (score 8.4)
  SEO    → APPROVE (score 8.0)

  ✅ CONSENSUS → git push → LIVE
```

```
ARTICLE: "Cost to Install Solar Panels in Key West 2026"

ROUND 1: Writer drafts → Editor REVISE → SEO REVISE → back to Writer
ROUND 2: Writer revises → Editor REVISE (fabricated incentive program) → SEO APPROVE
ROUND 3: Writer revises → Editor REVISE (still fabricating "Key West Solar Rebate 2026") → SEO APPROVE
ROUND 4: MAX REVISIONS HIT (3)

  ❌ QUARANTINED → saved to /quarantine/ → you review when you wake up
```

---

## FILE STRUCTURE

```
~/rivet-business/
├── night_shift.py              # Main orchestrator script
├── prompts/
│   ├── writer-system.txt       # Writer agent system prompt
│   ├── editor-system.txt       # Editor agent system prompt
│   ├── seo-system.txt          # SEO agent system prompt
│   └── article-template.txt   # The article structure template
├── logs/
│   ├── night-shift.log         # Stdout log
│   └── night-shift-error.log  # Error log
├── night-shift-log.md          # Nightly summary reports
└── quarantine/                 # Failed articles for human review

~/site-repo/
├── content/
│   ├── roofing/
│   ├── hurricane-protection/
│   ├── exterior/
│   ├── interior/
│   ├── plumbing/
│   ├── electrical/
│   ├── hvac/
│   ├── major-systems/
│   └── pool/
├── keyword-queue.md
├── publishing-log.md
└── weekly-status.md
```

---

## DEPLOYMENT STACK — Hugo + GitHub Actions + GitHub Pages

### How It Works

```
Rivet pushes markdown file
        │
        ▼
  GitHub repo (main branch)
        │
        ▼  (~60 seconds)
  GitHub Actions triggers
        │
        ▼
  Hugo builds static site
        │
        ▼
  GitHub Pages serves it live
        │
        ▼
  floridahomecosts.com is updated
```

### Step 1 — Create the GitHub Repo

1. Go to github.com → New repository
2. Name it: `florida-home-costs` (or similar)
3. Set to **Public** (required for free GitHub Pages)
4. Do NOT initialize with README — Rivet will push the first commit

### Step 2 — Install Hugo and Pick Theme

Recommended theme: **PaperMod** — fast, clean, excellent SEO defaults
- Proper meta tags out of the box
- Automatic sitemap generation
- Clean URLs (`/roofing/cost-to-replace-roof-fort-lauderdale-2026/`)
- Mobile-first, Google PageSpeed friendly

```bash
# On Mac mini
brew install hugo

# Clone your repo
git clone https://github.com/YOUR_USERNAME/florida-home-costs ~/site-repo
cd ~/site-repo

# Add PaperMod theme as submodule
git submodule add https://github.com/adityatelange/hugo-PaperMod themes/PaperMod

# Copy config and initial files from rivet-business/site-template/
cp ~/rivet-business/site-template/hugo.toml .
cp ~/rivet-business/site-template/keyword-queue.md .
cp ~/rivet-business/site-template/publishing-log.md .
cp ~/rivet-business/site-template/night-shift-log.md .
mkdir -p .github/workflows
cp ~/rivet-business/site-template/.github/workflows/deploy.yml .github/workflows/

# First push
git add .
git commit -m "Initial Hugo site setup"
git push origin main
```

### Step 3 — Enable GitHub Pages

1. Go to your repo on GitHub → **Settings** → **Pages**
2. Source: **GitHub Actions** (not branch)
3. That's it — GitHub Actions will handle everything from here

After the first push, GitHub Actions builds the site automatically.
Check progress under **Actions** tab in your repo.

### Step 4 — Custom Domain (Recommended)

1. Buy `floridahomecosts.com` on Namecheap or Cloudflare (~$10/yr)
2. In GitHub Pages settings → add your custom domain
3. Add DNS records at your registrar:
   ```
   Type  Name    Value
   A     @       185.199.108.153
   A     @       185.199.109.153
   A     @       185.199.110.153
   A     @       185.199.111.153
   CNAME www     YOUR_USERNAME.github.io
   ```
4. Enable **Enforce HTTPS** in GitHub Pages settings
5. Update `baseURL` in `hugo.toml` to your domain

### Step 5 — Update night_shift.py

Update `REPO_PATH` in the script:
```python
REPO_PATH = Path.home() / "site-repo"  # Already set correctly
```

The pipeline writes markdown to:
```
~/site-repo/content/{category}/{slug}-{year}.md
```

Then does `git add`, `git commit`, `git push` → GitHub Actions fires → live in 60s.

---

## SCHEDULING

### Option 1: Cron Job (simplest)
```bash
# Run every night at midnight EST
0 0 * * * cd /Users/dariusvitkus/rivet-business && python3 night_shift.py >> logs/night-shift.log 2>> logs/night-shift-error.log
```

### Option 2: Launchd (macOS native — better for Mac Mini)

Create `~/Library/LaunchAgents/com.rivet.nightshift.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.rivet.nightshift</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/python3</string>
    <string>/Users/dariusvitkus/rivet-business/night_shift.py</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>0</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>/Users/dariusvitkus/rivet-business/logs/night-shift.log</string>
  <key>StandardErrorPath</key>
  <string>/Users/dariusvitkus/rivet-business/logs/night-shift-error.log</string>
</dict>
</plist>
```

Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.rivet.nightshift.plist
```

---

## QUALITY SAFEGUARDS SUMMARY

| Safeguard | What It Prevents |
|---|---|
| Editor credibility score ≥ 9 | Fake testimonials, fabricated stats |
| Editor structure checklist | Missing sections, incomplete articles |
| SEO keyword density check | Keyword stuffing OR under-optimization |
| SEO technical checklist | Bad meta tags, broken heading hierarchy |
| Both agents must approve | One weak review can't let bad content slip through |
| Max 3 revision rounds | Infinite loops on unfixable articles |
| Quarantine system | Bad articles never go live |
| Nightly log | Full audit trail of everything published |

---

## WHAT YOU DO WHEN YOU WAKE UP

1. Check `night-shift-log.md` — see how many published vs quarantined
2. Glance at `publishing-log.md` — see editor/SEO scores for published articles
3. Check `/quarantine/` — if any articles failed, read the notes and decide:
   - Fix manually and publish
   - Delete (topic was a bad fit)
   - Add notes and re-queue the keyword
4. Refill `keyword-queue.md` if running low

Time commitment: ~10 minutes per morning.

---

## TUNING THE PIPELINE

After the first week, review patterns:

**If most articles pass on round 1:**
→ Tighten thresholds (raise min scores) — agents are too lenient

**If most articles take 3 rounds or get quarantined:**
→ Writer prompt needs improvement
→ Check what the common revision notes are
→ Update writer system prompt to preempt those issues

**If certain categories consistently fail:**
→ Model may lack knowledge in that area
→ Consider providing reference data in the writer prompt
→ Or skip that category and focus on what works

**If articles pass review but don't rank on Google (check after 30-60 days):**
→ Tighten SEO thresholds
→ Add a "competitive analysis" step before writing
→ Check if content is actually differentiated from top results

---

## IMPORTANT NOTES

- All three roles use the same model (Qwen 3.5-122B) with different system prompts.
  The editor doesn't know what the SEO agent said and vice versa — they review independently.

- The Writer sees ALL revision notes from both Editor and SEO **combined**.
  This prevents conflicting revisions from causing loops.

- Temperature 0.7 for Writer (creative), 0.3 for Editor and SEO (consistent evaluation).

- Token budget: ~2,000 word article ≈ 3,000 tokens. Each review ≈ 500 tokens.
  One full article cycle (write + 2 reviews) ≈ 4,000 tokens.
  With 3 revision rounds: ≈ 12,000 tokens max per article.
  5 articles per night ≈ 60,000 tokens. Qwen 3.5-122B on GX10 handles this easily.
