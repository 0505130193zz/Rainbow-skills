# Weekly report rules

## Monday planning mode

Treat Monday planning as a forward-looking task plan, not a retrospective report.

- Read every message authored by the user from the previous Monday 00:00 through Sunday 23:59:59 in `Asia/Shanghai` before drafting.
- Require complete pagination. If `has_more=true`, keep reading; do not write a partial weekly plan.
- Extract only actionable signals:
  - unfinished or blocked work that still needs action;
  - explicit “下周/周一/明天/之后继续” commitments, resolved relative to the message timestamp;
  - requested follow-ups, review corrections, handoffs, meetings, or delivery dates;
  - confirmed current-week assignments and schedule rows.
- Do not turn work already completed last week into a current-week task unless the message contains a distinct follow-up.
- Merge repeated discussion into one task. Default to a scan-friendly `类别：对象/主题` label; add an output or deadline only when it changes what the user needs to do.
- Apply recurring schedule items explicitly confirmed in [source-profile.md](source-profile.md). Treat them as standing user instructions until the user cancels or reschedules them.
- Expand date-triggered duties defined in [source-profile.md](source-profile.md) from the complete current schedule, including standing cross-project review work that is not represented by the user's project-team membership. Resolve current field names and dates before adding tasks, deduplicate repeated schedule rows, and keep distinct duties separate when they share a date.
- Lock tasks with an explicit date, deadline, meeting, or schedule row to the supported weekday.
- For other tasks that are clearly confirmed for the current week, build a reasonable Monday–Friday plan from dependencies, execution order, and workload. This derived placement is a planning choice, not a source-backed deadline.
- Do not leave early weekdays blank solely because confirmed current-week tasks are undated. Do not add unsupported work merely to make every row non-empty.
- Keep every planned task unchecked.
- Write no daily completion text, unfinished-reason text, review, reflection, or “today's summary”.
- Write no weekly summary or next-week summary. Preserve the template section/header but keep its content empty.
- When reusing a copied target, remove stale prior-week completion and summary content from the new week's editable cells while preserving table structure, styles, images, and headers.

## Performance without weaker evidence

- Fetch authored messages, independent project chats, schedule Base records, and path/template metadata concurrently, with no more than four active read streams. Pagination inside each stream remains exhaustive and ordered where required.
- Use cached resource locators only as hints. A direct title/type/parent/fingerprint check may replace repeated tree discovery; any mismatch requires full resolution.
- Validate each JSON capture on arrival and record a coverage receipt. Do not repeat a full parse of every page at the end when every receipt is successful and immutable.
- Prefer the verified Rainbow personal working master from [source-profile.md](source-profile.md) as the operational copy source after checking it against the canonical contract. Fall back to the canonical template plus the personal large-O transformation when the working master is missing or stale.
- Keep all writes to one document sequential. Reduce round trips with prepared payloads, scoped re-fetches after block-ID invalidation, comma-separated batch deletion, and a single final full acceptance fetch.

## Evidence and source priority

Use sources according to the claim being made:

1. **Completion:** the user's explicit first-person status, a directly attributable deliverable/edit, or another source that proves the user's result.
2. **Codex work evidence:** relevant task history and generated artifacts inside the reporting window can prove that the user performed an AI/workflow test and what it produced or revealed. They do not by themselves prove external delivery, adoption, or completion of a larger Skill/project.
3. **Ownership:** the Base project-member field or an explicit assignment/reassignment in the project group.
4. **Plan and timing:** the current Base schedule; a newer explicit group message may override timing.
5. **Support/review:** the user's concrete feedback, review record, decision, or coaching action and its effect.
6. **Style:** the supplied historical weekly report.
7. **Correction:** current unsolved comments on the target document.

Do not let a lower-priority source overclaim a higher-priority fact. In particular:

- A schedule proves planning, not completion.
- A teammate's message proves team activity, not the user's work.
- A group timing update does not change ownership unless reassignment is explicit.
- A historical report proves style, not current-week facts.
- A Codex task marked active, interrupted, or containing only a first-pass output proves activity/progress, not completion.

## Confidence gate

Assign each ledger item a confidence:

- **High:** direct completion/status statement, directly attributable deliverable/edit, explicit assignment, or exact comment-to-block relation.
- **Medium:** concrete review/support action, linked artifact with incomplete authorship context, or two consistent contextual sources.
- **Low:** schedule-only completion inference, team-level mention, vague acknowledgement, quote-only comment match, or unverified recollection.

State completed work only with high-confidence evidence. Use medium-confidence evidence for cautious progress/support wording when ownership is clear. Exclude low-confidence claims or list them as unresolved internal questions; never promote them to completed checklist items.

## Ownership and status

- Derive the current user's `open_id` from verified auth status; never reuse a stale hard-coded ID.
- If the user appears in the Base `项目组` field or receives an explicit assignment, classify the work as direct.
- If the user is not in `项目组` but provides concrete feedback, review, or coaching, classify it as `育人 / 项目支持`.
- If the project is still in writing or scheduling and production has no confirmed start, write `跟进稿件状态与制作排期`; do not claim production started.
- If sources disagree, prefer the newest explicit update, record the conflict internally, and avoid a stronger claim than the evidence permits.
- Keep `done`, `planned`, `blocked`, and `support` distinct. A blocked item is not completed merely because work occurred around it.

## Inclusion threshold

Include work that produced meaningful output, progress, decision, problem discovery, or next action:

- direct project production and confirmed scheduling work;
- AI workflow tests with usable/non-usable conclusions;
- concrete process, knowledge, or standard artifacts;
- meetings that changed a decision or execution plan;
- coaching or review with specific feedback and impact;
- substantive temporary requests with an identifiable result.

Exclude low-signal actions unless they produced a meaningful result:

- merely sending a Skill, link, image, or test package;
- one-off bot triggers, mentions, or routine acknowledgements;
- duplicate status messages;
- administrative activity unrelated to a work outcome.

Keep excluded activity only as internal supporting context.

## Checklist rules

- Mark `done="true"` only for evidence-backed completion.
- In a daily closeout, distinguish completion of the day's intended step from completion of the whole project. When the user has manually checked an item, or direct first-person evidence says the day's scoped step is done, preserve that state even if the completion prose also names broader testing or follow-up work. State the remaining work plainly instead of silently unchecking the item.
- Current manual checkbox edits outrank an earlier derived state. Never reverse them merely because a Codex task is still active or the larger project continues.
- Leave current/future or unverified tasks `done="false"`.
- In Monday-planning mode, all current-week tasks must be `done="false"`; do not pre-complete Monday items.
- Clear stale completion states copied from a previous report when they do not belong to the selected week.
- Prefer short labels that tell the user what bucket the work belongs to and what the object is. Keep process details, message history, feedback context, and implementation steps out of the checkbox unless they are necessary to disambiguate the task.
- Use concise labels, for example:
  - `项目推进：示例项目A`
  - `AI：分镜skills迭代`
  - `育人：审核示例项目B`
  - `部门周会`
- When the same ongoing project spans multiple weekdays, reuse the same label. Do not fabricate different daily substeps without explicit evidence.
- Avoid labels that describe transmission only, such as `分享测试包`.
- Do not fabricate later-week completion when writing midweek.

## Template structure

Before any create or write, read [template-contract.md](template-contract.md). Its canonical Rainbow layout is mandatory unless the user supplies a different template in the current request. The current-request template overrides the canonical template; historical reports are style evidence only and must not be used to invent a different layout.

Preserve these sections when present:

1. 上周遗留待办
2. 本周工作计划
3. 本周任务（OKR 拆解）
4. 周一至周五每日待办与完成情况
5. 本周总结（下周待办）

Treat the visual/current OKR area under `本周工作计划` separately from prose. If a new OKR is not confirmed, leave that area unchanged or blank according to the template. Do not invent an OKR.

Preserve confirmed KR headings and update only the weekly task lines when appropriate. Do not copy stale tasks merely because they exist in the template.

In Monday-planning mode, keep the `本周总结（下周待办）` header and the daily completion/review column structure, but leave their content empty.

Never replace the canonical three-column table with a two-column task table, remove the OKR image area, remove the completion/review column, or delete the weekly-summary rows. Populate only the intended cells and leave prohibited content blank.

## Writing and review style

- Write the visible report around the work itself, not around the evidence-collection or implementation process. A useful item normally contains the work object, what changed today, the current result or limit, and—only when it affected the work—the user's judgment, team consequence, or next action.
- Keep thinking attached to the concrete work that produced it. “Thinking” means a real choice, criterion, tradeoff, correction, or stopping decision; do not manufacture a separate philosophical lesson or translate a plain observation into abstract methodology.
- Express the team angle through actual use: who will use the result, what shared reference or decision it creates, what friction remains, or what the team does next. Do not add generic claims about “team value”, “collaboration efficiency”, or “methodological significance”.
- Treat the evidence ledger, filenames, configuration keys, schema names, validation counts, and test harness details as internal by default. Include a concrete count only when it explains the scale or status of the work; include an implementation detail only when the conclusion is impossible to understand without it.
- Report failed attempts candidly: what was tried, what currently works, where it fails, how that failure affects real use, and whether the user decided to continue, change route, or stop. A clear `没成功 / 还没找到问题 / 先放弃` is better than disguising failure as progress.
- For ordinary progress, prefer a compact overall status over a detailed activity list. Do not enumerate every small edit merely to make the report look specific.
- For animation projects, prefer this evidence-backed progress line when the source supports the values: `动画：分镜梳理{n}%+风格收集/制作包装{n}%+排版{n}%+动画{n}%`. Add one to three short sentences only for a material bottleneck, current stage, feedback, or delivery state. Never invent a percentage; when the sources do not support one, use a cautious stage description instead.
- Use reflection only when the evidence shows a mistake, rework, failed judgment, avoidable delay, blocker, or feedback that corrected the approach. In those cases, state what was misjudged, why it mattered, and the concrete correction. Do not append a lesson or next action to every normal completion item.
- In Monday-planning mode, use concise `类别：对象/主题` tasks and omit retrospective prose. Add an expected output/decision only when the short label would be ambiguous.
- Preserve the user's candid, first-person voice while condensing repeated messages and correcting obvious typos.
- Do not inflate informal evidence into corporate-sounding achievements.
- Avoid empty official-sounding closeout language such as `接手并补齐`、`复核包装`、`推进优化` or `完成交付` when a plain progress statement is more accurate.
- Keep AI-related lessons inside the AI section rather than creating a separate generic review category.
- For AI work, capture the test target, result, failed or weak direction, correction, and current state when those facts exist. Do not reduce substantive work to `在 Codex 跑了一版`; do not call a Skill complete until its intended examples or validation are actually complete.
- Use a separate project/support category only when the work is genuinely non-AI.
- For a midweek report, use `阶段性总结（截至周X）` with the actual weekday.
- Keep unknowns explicit; do not fill blank areas for visual completeness.

Use Chinese numbered category headings such as `1、AI`. When the template uses blue underlined headings, preserve or create the equivalent XML style:

```xml
<p><u><span text-color="blue">1、AI</span></u></p>
```

Apply the same style consistently to sibling categories in completion and summary areas.

## Comment corrections

- Query unsolved comments by default.
- Treat a matched `relation.positionInfo.blockID` as exact; treat `parent_type`/`parent_token` as exact only to the parent embedded resource.
- Label quote-only matching as inference and do not guess when duplicate text makes the location ambiguous.
- Verify the requested correction against current messages, schedules, and document content.
- Remove unsupported content instead of defending it.
- Apply one correction consistently to checklist, completion text, and summary.
- Do not resolve a comment unless the user asks.

## Acceptance checks

Before handoff, verify:

- existing titles are preserved during narrow closeout edits; newly created formal reports have no test marker unless explicitly requested;
- the reporting window, dates, and weekday rows are correct;
- the OKR visual area was not populated with invented prose;
- direct ownership matches Base membership or explicit assignment;
- future/unverified days remain unchecked;
- low-signal actions and private evidence IDs are absent;
- AI review stays inside AI;
- category headings retain the target's required style in `--detail full` output;
- every comment correction is reflected in all duplicate mentions;
- no unrelated block, image, comment, or table dimension changed.
- the daily evidence receipt includes a proactive review of relevant Codex tasks active or updated during the reporting window, with active/interrupted/first-pass work kept distinct from completion;
- in Monday-planning mode, the previous week's authored-message range is complete, all current-week tasks are unchecked, daily completion/review cells are empty, and weekly-summary content is empty.
