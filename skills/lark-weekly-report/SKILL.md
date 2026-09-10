---
name: lark-weekly-report
description: 从本人飞书消息、排期与相关 Codex 任务生成和更新有依据的周报。用于周一计划、每日收尾、周总结、写入飞书模板、按评论修订及周报依据核查。
---

# Lark Weekly Report

Use the installed `lark-cli` with the signed-in user's identity. Prefer CLI access over browser automation whenever the CLI supports the resource.

This skill reads messages and edits authorized report documents; it does not send or reply to Feishu messages. Never use user identity or a raw API to send messages.

## Load the operating rules

Read source-profile.local.md from references/ when present. It supplies private resource links and confirmed personal conventions. Never treat the distributed examples as configured resources or confirmed duties. Current user instructions take priority.

Read these files before executing a report task:

- [references/report-rules.md](references/report-rules.md) — evidence, ownership, inclusion, writing, and acceptance rules.
- [references/cli-recipes.md](references/cli-recipes.md) — Windows-safe capture, pagination, document editing, comments, and failure handling.
- [references/source-profile.md](references/source-profile.md) — personal discovery hints; treat them as resolvable hints, never immutable IDs.
- [references/template-contract.md](references/template-contract.md) — canonical Rainbow weekly-report layout and structural acceptance fingerprint. Read it before every create or write.

Read the version-matched embedded Lark skill before using each service:

- Always read `lark-shared`.
- For messages, read `lark-im`, `references/lark-im-messages-search.md`, and `references/lark-im-chat-messages-list.md`.
- For documents, read `lark-doc`, `references/lark-doc-fetch.md`, `references/lark-doc-update.md`, `references/lark-doc-xml.md`, `references/style/lark-doc-style.md`, and `references/style/lark-doc-update-workflow.md`.
- For schedules, read `lark-base` and `references/lark-base-data-analysis-sop.md`.
- For comments, read `lark-drive`, `references/lark-drive-comments-guide.md`, and `references/lark-drive-comment-location.md`.

On Windows, run user-identity commands in a host environment that can access the OS credential store. Never interpret a restricted sandbox's `missing` or `not_configured` result as proof that the user must reauthorize. Verify in the host environment first.

## Select the execution mode

Classify the request before collecting data:

- **Monday plan:** when the user asks on Monday for this week's report, or asks to derive this week's tasks from last week's messages, read every authored message from the previous Monday through Sunday before drafting. Write plans and unchecked tasks only; do not write daily completion/review text or a weekly summary.
- **Draft only:** collect evidence and return a draft; do not edit Feishu.
- **Write target:** fill or update the target explicitly named by the user. The direct request to write is sufficient intent; do not ask for redundant confirmation.
- **Comment iteration:** apply current unsolved comments to the named target; do not resolve comments unless explicitly asked.
- **Evidence audit:** inspect sources and report gaps or contradictions without drafting or writing.

Never turn a draft-only or audit request into a write. If a write target cannot be distinguished from a style sample or schedule source, ask for the target URL.

## Establish the reporting window

Use the user's explicit dates over defaults.

- For **Monday plan**, keep two ranges separate:
  - evidence window: the previous Monday 00:00 through Sunday 23:59:59;
  - target week: the current Monday through Friday.
- “本周/这周”: Monday 00:00 through the current time in `Asia/Shanghai`.
- “上周”: the previous Monday 00:00 through Sunday 23:59:59 in `Asia/Shanghai`.
- Display the Monday–Friday workweek belonging to the selected reporting window.
- Include weekend evidence only when it materially belongs to that workweek; do not invent weekend checklist rows.
- If the user's wording names conflicting weeks and the choice would change the report, ask one concise question.

Record the resolved evidence start/end, target-week dates, and timezone before querying. Never substitute the nearly empty current-Monday message window for the previous week's evidence window.

## Run the scheduled closeout mode

The following cadence is a workflow convention, not authorization to create an automation. Run closeouts only when requested or invoked by an already authorized schedule. Use `Asia/Shanghai` unless the user configures another timezone:

- Every Monday through Friday at 19:00, run a **daily closeout** for the current weekday. Read every message authored by the signed-in user from 00:00 through the run time, paginate to `has_more=false`, and resolve only the surrounding conversations needed to verify ownership, outcome, blockers, feedback, or next actions. Locate the existing formal report for the current Monday–Friday week and update only that weekday's `完成情况及未完成原因/复盘` cell, plus evidence-backed completion states when appropriate. Preserve all unrelated manual edits and document structure.
- During every daily closeout, proactively inspect Codex tasks active or updated inside the same evidence window. Read the relevant task history when it contains substantive work attributable to the user, even when the user did not mention it in Feishu or remind the agent. Include verified outputs, decisions, failed attempts, blockers, and current state; an active, interrupted, or first-pass task is not proof of completion. Exclude the reporting automation itself and unrelated/private tasks with no credible work-report relevance.
- On Friday at 19:00, perform the daily closeout first, then run a **weekly closeout** in the same sequential job. Read the complete current-week authored-message window from Monday 00:00 through the run time, paginate to `has_more=false`, and fill `本周总结（下周待办）` with a concise retrospective and only unfinished follow-ups, explicit next-week commitments, or confirmed schedules. Keep every new next-week task unchecked.

Do not run Friday daily and weekly closeouts as concurrent writers. If the current week's formal report cannot be uniquely located, or any required message range remains incomplete, stop without writing and report the ambiguity or coverage gap.

## Run preflight

1. Run `lark-cli auth status --json --verify` in the host environment.
2. Require a verified, available user identity. Accept `needs_refresh` when server verification succeeded; the next user API call can refresh automatically.
3. Initialize UTF-8 output and suppress update/skills notices for machine-readable commands.
4. Validate every saved JSON capture as strict UTF-8 and parseable JSON. Stop before analysis or writing if a capture is malformed or contains mojibake.
5. Treat API success as exit code `0` and envelope `ok == true`; `auth status` uses its own `verified` contract.

Use `scripts/preflight.ps1` for a repeatable auth and capture check when working in PowerShell.

## Collect evidence before drafting

Collect first; summarize only after the relevant source ranges are complete.

1. Search all messages authored by the signed-in user within the evidence window and paginate exhaustively. In Monday-plan mode, the complete previous week is mandatory; do not draft if any message page remains unread.
2. Inspect Codex tasks active or updated in the evidence window and resolve the relevant task histories. Treat them as supplemental first-party work evidence, not as automatic completion proof; distinguish generated output, validated result, failed/interrupted attempt, and remaining work.
3. Resolve linked documents, deliverables, or discussions that materially support a claimed result.
4. Resolve the project group and read the weekly stream when assignment, review, timing, or ownership depends on group context. Inspect relevant thread replies.
5. Resolve the schedule Base, inspect actual tables and fields, and query records involving the signed-in user's current `open_id`.
6. Read the user-supplied or canonical target template and the historical style sample as separate resources. A template supplied in the current request has highest authority. Never edit the template, sample, Base, or project group.
7. For comment iteration, list every current unsolved comment with `need_relation=true` and map it to current document blocks.

Do not silently stop at an auto-pagination cap. Continue from the returned token while `has_more=true`, or state the incomplete range before proceeding.

### Optimize evidence collection without weakening coverage

- Run independent read-only sources concurrently, with at most four active `lark-cli` read streams: authored-message search, project-chat reads, schedule Base reads, and template/path discovery. Keep pagination sequential within each source and require a separate coverage receipt ending in `has_more=false`.
- Use the largest page size supported by each command. Validate each capture immediately when it is produced; at handoff, validate the compact receipt/manifest rather than reparsing every already-validated page.
- Reuse previously verified space, month-node, Base table, and field locators from automation memory only as discovery hints. Confirm title, resource type, parent, and expected fingerprint with one direct read; fall back to full resolution on any mismatch.
- Never parallelize writes to the same document or location.

## Build the evidence ledger

Normalize candidates internally before writing:

```text
event_time | work_date | category | claim | status | ownership | evidence_type | source_locator | confidence | notes
```

Merge duplicate mentions of the same work. Separate `done`, `planned`, `blocked`, `support`, `carryover`, `commitment`, and `deadline`. In Monday-plan mode, convert only unfinished work, explicit follow-ups, current-week commitments, and confirmed schedules into tasks; completed work remains evidence context rather than a new task. Apply [references/report-rules.md](references/report-rules.md) to decide whether each claim is included and how strongly it may be stated.

After normalizing evidence, apply confirmed recurring schedule items and wording preferences from [references/source-profile.md](references/source-profile.md). A current user instruction overrides the stored profile.

Keep private IDs, raw messages, access links, and the ledger out of the weekly report and final response.

## Draft and update

1. Draft from the ledger, then compare the draft against the target's actual sections and the historical style sample.
2. Treat the selected template as the structural source of truth. Preserve its title convention, table/merge map, column widths, images, headers, comments, checkboxes, and styles. Never replace it with a different column count or a newly invented layout.
3. Leave future or unverified tasks unchecked. Never convert a schedule entry into a completion claim.
4. For planning checkboxes, prefer a short `类别：对象/主题` label and keep evidence or execution detail in the internal ledger. Expand the label only when needed to distinguish similar work or preserve an explicit deliverable/deadline. For ordinary project progress, report the overall stage compactly; for animation work, prefer evidence-backed percentages for `分镜梳理`、`风格收集/制作包装`、`排版`、`动画`, followed by only the material bottleneck and current state. Add reflection or a corrective next action only when evidence shows a mistake, rework, failed judgment, blocker, or feedback-driven correction; do not force every item into a lesson.
5. For a write, fetch current target structure and revision immediately before editing. Prepare all XML payloads before the first write. Use the smallest block-level change, dry-run structural edits, sequential writes, and the returned revision. After an ID-invalidating operation, re-fetch only the smallest `range`/`keyword` fragment that contains the remaining target blocks when that is sufficient; use a new full fetch only when the whole-table fingerprint must be re-established.
6. Avoid `overwrite` for report-template filling. Pass the current revision when supported so concurrent edits fail safely instead of being overwritten.
7. For comments, update every duplicate occurrence of the corrected issue across checklist, completion text, and summary.

For Monday-plan mode:

- Fill only planning areas such as `上周遗留待办`, `本周工作计划`, confirmed `本周任务（OKR 拆解）`, and the Monday–Friday task/checklist cells.
- Keep every new task unchecked.
- Add confirmed recurring items from `source-profile.md` on their fixed weekday unless the user explicitly cancels or reschedules them.
- Lock tasks with an explicit date, deadline, meeting, or schedule row to the supported weekday.
- Distribute other confirmed current-week tasks across Monday–Friday using dependencies, execution order, and reasonable workload balance. Treat this as a planning sequence, not as evidence of a hard deadline.
- Reuse the same concise label across weekdays when a task is continuous; do not invent day-specific execution steps merely to make the plan look detailed.
- Do not leave Monday or Tuesday blank merely because confirmed current-week work lacks an explicit date. Never add unsupported work just to fill a weekday.
- Keep all `完成情况及未完成原因/复盘` cells empty. Clear stale copied completion text from a reused target without deleting the table structure or headers.
- Keep `本周总结（下周待办）` content empty. Preserve the section header/structure, but clear stale copied summary content and do not generate replacement text.
- Use the formal title `Rainbow工作周报（M.D-M.D）` by default. Never add `【测试】`, `测试`, or another test marker unless the user explicitly requests a test document in the current request.

## Verify and hand off

Re-fetch the final target and verify:

- the formal title and absence of test markers, unless the current request explicitly asked for a test document;
- report dates and weekday placement;
- table structure, widths, images, and comments;
- the canonical template fingerprint from `references/template-contract.md`;
- completion states and ownership;
- in Monday-plan mode, complete previous-week message coverage, unchecked tasks, empty daily completion/review cells, and empty weekly-summary content;
- required category styling;
- comment corrections and duplicate mentions;
- absence of low-signal or unsupported claims;
- final revision ID and API warnings.

Use one final `--detail full` target fetch for acceptance. For read-only templates and historical reports, the write-target ledger plus an unchanged revision is sufficient; re-fetch their full content only if the revision changed. When a verified working master was copied, validate the three image blocks and structural fingerprint without downloading binaries; perform binary hash comparison only when images were migrated or reconstructed during the run.

Return the target link, the verified revision when available, and a compact summary of what changed. Mention missing evidence, unresolved ambiguity, incomplete pagination, or permissions only when they affect the result.
