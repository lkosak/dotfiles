---
name: productivity-analysis
description: Analyze an engineer's productivity over the past year using GitHub data, Unblocked context, and organizational data
---

# Productivity Analysis Skill

Analyze an individual engineer's productivity and impact over the past year for R&R calibration.

## Trigger

User says: "Analyze [name]'s productivity", "/productivity-analysis [name]", "productivity analysis for [name]"

## Parameters

- **engineer_name**: Full name of the engineer (required)
- **github_username**: GitHub username (will be inferred if not provided)
- **analysis_period**: Default "2025 calendar year" (Jan 1 - Dec 31, 2025)

## IMPORTANT: Date Range for Calibrations

**For year-end calibrations, use 2025 calendar year only (Jan 1 - Dec 31, 2025).**

Do NOT include 2026 data. The calibration is evaluating 2025 performance.

## Data Sources

### Primary: GitHub Enterprise API

Use the `gh` CLI with GraphQL to pull all data in a single query. **Important:** Use `GH_HOST=github.plaid.com` environment variable:

```bash
# Get all PRs authored AND reviewed by the engineer across all relevant repos in one query
# Adjust repos based on engineer's team (see Team-to-Repo Mapping below)
GH_HOST=github.plaid.com gh api graphql -f query='
{
  authored: search(
    query: "author:{username} is:pr is:merged merged:2025-01-01..2025-12-31"
    type: ISSUE
    first: 100
  ) {
    issueCount
    pageInfo {
      hasNextPage
      endCursor
    }
    edges {
      node {
        ... on PullRequest {
          number
          title
          createdAt
          mergedAt
          additions
          deletions
          changedFiles
          repository {
            name
          }
        }
      }
    }
  }
  reviewed: search(
    query: "reviewed-by:{username} is:pr is:merged merged:2025-01-01..2025-12-31"
    type: ISSUE
    first: 1
  ) {
    issueCount
  }
}
'
```

**Pagination:** If the engineer has >100 PRs, use the `endCursor` value with pagination:

```bash
# For subsequent pages
GH_HOST=github.plaid.com gh api graphql -f query='
{
  authored: search(
    query: "author:{username} is:pr is:merged merged:2025-01-01..2025-12-31"
    type: ISSUE
    first: 100
    after: "{endCursor_from_previous_page}"
  ) {
    # same fields as above
  }
}
'
```

#### PR Reviews Analysis

The review count is included in the main GraphQL query above (see `reviewed` section). This metric is important because:
- Shows team citizenship and collaboration
- Senior engineers often have lower PR counts but higher review counts
- Low review counts may indicate siloed work patterns

**Note:** The single combined query above fetches both authored PRs (with full details) and review counts simultaneously, eliminating the need for separate API calls per repository.

### Secondary: Unblocked Context Engine

Use the Unblocked MCP tool (`mcp__unblocked__unblocked_context_engine`) to gather:
- Project context and business impact
- Team contributions and cross-functional work
- Historical context on major initiatives
- Feedback and peer reviews

Query patterns:
- "{engineer_name} contributions 2025"
- "{engineer_name} {project_name} impact"
- "{engineer_name} feedback review"

### Tertiary: Plaid Roster

Query roster for:
- Current role and level
- Team membership
- Manager chain
- Start date (for tenure context)

## Start Date Handling

**CRITICAL:** When calculating averages (PRs/month, LOC/month), use the engineer's **actual start date**, not January 2025.

1. Check roster or onboarding docs for start date
2. Calculate averages only from first active month
3. Note tenure in the report header

Example: If engineer joined Sept 2025 and has 25 PRs:
- **Wrong:** 25 PRs / 13 months = 1.9 PRs/month
- **Correct:** 25 PRs / 5 months (Sept-Jan) = 5.0 PRs/month

## Output Format

Create file: `notes/productivity-analyses/individual/{engineer-name-lowercase}-productivity-analysis.md`

### Structure

```markdown
# Developer Productivity Analysis: {Full Name}

**Analysis Period:** January 2025 - January 2026
**Tenure Period:** {start_date} - January 2026 ({X} months) ← USE THIS FOR AVERAGES
**Data Source:** GitHub Enterprise API
**Generated:** {date}
**GitHub Username:** {username}

---

## Executive Summary

| Metric | Value |
|--------|-------|
| **Start Date** | {start_date} |
| **Tenure** | {X} months |
| **Total PRs Authored** | {count} |
| **Total PRs Reviewed** | {review_count} |
| **Total Lines Added** | {loc_added} |
| **Total Lines Deleted** | {loc_deleted} |
| **Net Lines of Code** | +{net_loc} |
| **Average PRs/month** | {avg} ← CALCULATE FROM TENURE, NOT 13 MONTHS |
| **Average LOC/PR** | {avg_loc} |
| **Review Ratio** | {reviews/authored} |
| **Peak PR month** | {month} ({count} PRs) |
| **Peak LOC month** | {month} ({loc} lines) |

---

## Monthly Metrics

| Month | PRs | LOC Added | LOC Deleted | Net LOC | Complexity |
|-------|-----|-----------|-------------|---------|------------|
| Jan '25 | X | Y | Z | +N | 2.X |
...

---

## PR Count Trend (Visual) - WITH PROJECT ANNOTATIONS

```
Month      | PRs | Distribution                              | Project Phase
-----------|-----|-------------------------------------------|---------------------------
2025-09    |   3 | ██████████                                | ← Onboarding/ramp-up
2025-10    |   0 |                                           | ← Gap (training?)
2025-11    |   8 | ██████████████████████████████████████████| ← Portal Names delivery
2025-12    |   8 | ██████████████████████████████████████████| ← Panorama UI hardening
2026-01    |   6 | █████████████████████████                 | ← ACH verification (partial)
```

**REQUIRED ANNOTATIONS:**
- Label each spike with the project/initiative that drove it
- Note gaps and explain (vacation, training, blocked, etc.)
- Mark onboarding period for new hires
- Indicate delivery milestones

---

## Lines of Code Trend (Visual) - WITH PROJECT ANNOTATIONS

```
Month      | +Lines  | -Lines  | Net     | Project/Initiative
-----------|---------|---------|---------|----------------------------------------
2025-09    | +444    | -99     | +345    | ← Onboarding: Classic Dashboard cards
2025-10    |   0     |   0     |   0     | ← No activity (ramp-up gap)
2025-11    | +1,170  | -557    | +613    | ← PEAK: Portal Names feature delivery
2025-12    | +580    | -89     | +491    | ← Panorama UI hardening, ACH flow
2026-01    | +269    | -52     | +217    | ← ACH verification, Slack notifications
```

**CRITICAL:** Every row should have a Project/Initiative annotation explaining what drove that month's output. This is essential context for calibration.

### How to Identify Projects for Annotations

1. **Group PRs by title patterns** - Look for common prefixes or keywords
2. **Check Work Categories section** - Map categories to months
3. **Use PR titles** - Extract project names from PR titles
4. **Cross-reference with peer feedback** - Peers often mention specific projects
5. **Ask Unblocked** - Query for "{engineer} projects {month} 2025"

---

## Repository Breakdown

| Repository | PRs | % of Total | LOC Added | LOC Deleted | Net LOC |
|------------|-----|------------|-----------|-------------|---------|
| go         | X   | Y%         | Z         | A           | +B      |
...

---

## Work Categories

Analyze PR titles to categorize work:
- Feature development
- Bug fixes
- Infrastructure/tooling
- KTLO/maintenance
- Testing
- Documentation

---

## PR Size Distribution

| Size | LOC Range | Count | % |
|------|-----------|-------|---|
| XS   | <50       | X     | Y% |
| S    | 50-200    | X     | Y% |
| M    | 200-500   | X     | Y% |
| L    | 500-1000  | X     | Y% |
| XL   | >1000     | X     | Y% |

---

## Key Projects & Impact

Use Unblocked to enrich with project context:
1. {Project 1}: {description of contribution and impact}
2. {Project 2}: {description of contribution and impact}

---

## Key Observations

### Strengths
1. ...
2. ...

### Patterns
- Q1 2025: ...
- Q2 2025: ...
- Q3 2025: ...
- Q4 2025: ...

### Areas for Discussion
- ...

---

## DORA/Productivity Metrics (if available)

| Metric | Value | Interpretation |
|--------|-------|----------------|
| **Output Consistency Score** | X% | variance analysis |
| **Monthly Velocity** | X LOC/month | relative to peers |
| **PR Frequency** | X PRs/month | cadence assessment |
| **Average PR Size** | X LOC | reviewability |

---

## Calibration Notes

**Pre-calibrated Rating:** {if known}
**Productivity Data Supports:** {assessment based on data}
**Flags for Discussion:** {any concerns or discrepancies}

---

*Analysis generated by Claude Code using GitHub Enterprise API data and Unblocked context.*
```

## Complexity Scoring

Score each month 1-5 based on:
- **5:** >1000 LOC + scaffolding/new service creation
- **4:** 500-1000 LOC or major feature delivery
- **3:** 200-500 LOC, standard feature work
- **2:** 50-200 LOC, maintenance/enhancements
- **1:** <50 LOC, small fixes

## Calibration Cross-Reference

When pre-calibrated ratings are provided:
1. Compare PR volume/LOC to peers at same level
2. Flag if low PR count with high rating (needs justification)
3. Flag if high PR count with low rating (may be underrated)
4. Note any extended low-output periods (vacation? reassignment? burnout?)

## Key Metrics to Calculate

From Plaid's Engineering Productivity Program:
- **PR Lead Time for Change**: Time from PR open to merge
- **Deployment Frequency**: PRs merged per week
- **PR Volume**: Total PRs per month
- **LOC Changed**: Proxy for activity volume
- **Innovation Ratio**: Feature work vs KTLO (estimate from PR titles)

## Tips for Analysis

1. **SVG/Asset Inflation**: Flag large LOC from asset files (SVG, JSON fixtures) - note actual code LOC separately
2. **Vacation/Leave**: August often shows dips - verify before flagging
3. **Project Phases**: Early project phases have high LOC (scaffolding), mature phases have lower LOC
4. **Role Context**: Senior engineers may have lower PR counts but higher-impact reviews
5. **Cross-repo Work**: Some engineers work across multiple repos - aggregate properly

## GitHub Username Resolution

Common patterns:
- First initial + last name: jsmith
- First name initial + middle initial + last name: jmsmith
- First name: john
- Check Plaid roster or ask Unblocked: "What is {name}'s GitHub username"
