# FLAG Groups — Link-Level Ambiguity Breakdown

Total link-level FLAGs (file-level rule relaxed): **71**

| Group | Description | Count |
|---|---|---|
| A | City mismatch (slug+topic+anchor all match, different city) | 63 |
| B | Anchor specificity mismatch (slug ≥0.93, anchor diverges) | 8 |
| C | Weak-band match (slug 0.65-0.85, middling anchor) | 0 (routed to STRIP by safer-default rule) |
| D | Other | 0 |


## Group A — City mismatch (63)

### Top patterns

- (29×) target=miami cand=tampa
- (10×) target=orlando cand=tampa
- (5×) target=orlando cand=florida
- (2×) target=jacksonville cand=davie
- (2×) target=key-west cand=weston

### 3 sample links

- **electrical/cost-to-install-ev-charger-in-miami-2026.md:171**
  - link: `[Cost to Install Impact Windows in Miami 2026](/hurricane-protection/cost-to-install-impact-windows-miami-2026/)`
  - best candidate: `/hurricane-protection/cost-to-install-impact-windows-tampa-2026/`
  - signals: topic_jac=1.00 slug=0.93 anchor=1.00
  - reason: topic+slug match but city mismatch: target=miami cand=tampa

- **electrical/cost-to-install-ev-charger-in-orlando-2026.md:167**
  - link: `[Cost to Install Impact Windows in Orlando](/electrical/cost-to-install-impact-windows-orlando-2026/)`
  - best candidate: `/hurricane-protection/cost-to-install-impact-windows-tampa-2026/`
  - signals: topic_jac=1.00 slug=0.88 anchor=1.00
  - reason: topic+slug match but city mismatch: target=orlando cand=tampa

- **electrical/cost-to-install-whole-house-generator-in-miami-2026.md:171**
  - link: `[Cost to Install Impact Windows in Miami](/hurricane-protection/cost-to-install-impact-windows-miami-2026/)`
  - best candidate: `/hurricane-protection/cost-to-install-impact-windows-tampa-2026/`
  - signals: topic_jac=1.00 slug=0.93 anchor=1.00
  - reason: topic+slug match but city mismatch: target=miami cand=tampa


## Group B — Anchor specificity mismatch (8)

### Top patterns

- (5×) target_topic='ac unit' cand_topic='ac'
- (1×) target_topic='ac' cand_topic='ac'
- (1×) target_topic='vinyl plank floors' cand_topic='vinyl plank flooring'
- (1×) target_topic='pump' cand_topic='sump pump'

### 3 sample links

- **hvac/cost-of-duct-cleaning-in-tampa-2026.md:165**
  - link: `[Cost to Replace AC Unit in Tampa 2026](/hvac/cost-to-replace-ac-unit-tampa-2026/)`
  - best candidate: `/hvac/cost-to-replace-ac-in-tampa-2026/`
  - signals: topic_jac=0.50 slug=0.94 anchor=0.50
  - reason: slug nearly-identical 0.94; anchor=0.50 (likely city/year/word mismatch — review)

- **hvac/cost-to-clean-ac-coils-in-tampa-2026.md:167**
  - link: `[Cost to Replace AC Unit in Tampa 2026](/hvac/cost-to-replace-ac-unit-tampa-2026/)`
  - best candidate: `/hvac/cost-to-replace-ac-in-tampa-2026/`
  - signals: topic_jac=0.50 slug=0.94 anchor=0.50
  - reason: slug nearly-identical 0.94; anchor=0.50 (likely city/year/word mismatch — review)

- **hvac/cost-to-clean-air-ducts-in-florida-2026.md:163**
  - link: `[Cost to Replace AC Unit in Florida 2026](/hvac/cost-to-replace-ac-unit-florida-2026/)`
  - best candidate: `/hvac/cost-to-replace-ac-in-florida-2026/`
  - signals: topic_jac=0.50 slug=0.94 anchor=0.50
  - reason: slug nearly-identical 0.94; anchor=0.50 (likely city/year/word mismatch — review)

