# Rainbow workflow conventions (shareable)

Private links have been removed. Read `source-profile.local.md` when present; create it from [source-profile.example.md](source-profile.example.md). The names, fixed duties, OKR groups, and historical dates below document the original Rainbow workflow. Apply them only when the local profile or current user confirms that workflow; otherwise use the current user template, duties, and title. Missing optional samples are a coverage limitation, not permission to invent a resource.

Use these values only as discovery hints. Resolve every resource again with the CLI and prefer resources explicitly supplied by the user in the current request.

## Current hints

- Report owner display names: `Rainbow` / `报告作者`
- Canonical Rainbow weekly-report template: `（从本地 source-profile.local.md 读取对应链接）`
- Verified Rainbow personal working master: `（从本地 source-profile.local.md 读取对应链接）` (`Rainbow周报个人母版（只读工作副本）`). It contains the approved three OKR images, large-O layout, five weekday rows, empty completion/review cells, and an empty weekly-summary content row. Treat it as read-only and replace every mutable task region in the new copy; never write weekly content back to the master.
- Historical style reference: `（从本地 source-profile.local.md 读取对应链接）`
- Schedule Base: `（从本地 source-profile.local.md 读取对应链接）`
- Expected Base title: `内容部大表`
- Expected schedule table: `2026年项目管理表`
- Project group: `项目沟通交流群`

## Personal planning conventions

- Keep Rainbow's planning checkboxes short and immediately scannable. Store evidence and execution detail in the internal ledger rather than the visible task label.
- Direct project work: use `项目推进：{项目名}`, for example `项目推进：示例项目A`.
- AI workflow work: use `AI：{主题}`, for example `AI：分镜skills迭代`.
- Every Friday has a fixed `部门周会`. Add it to the Friday checklist with `done="false"` in every Monday plan unless the user explicitly cancels, reschedules, or the selected workweek has no Friday workday.
- Every Monday plan must inspect the complete current project-schedule Base for date-triggered review work, not rely only on authored messages or rows where Rainbow is listed in the project team. For each project whose schedule start date falls on a Monday-Friday in the target week, add the unchecked task `项目推进：审核{项目名}包装` on that exact date; for example, `项目推进：审核示例项目B包装`.
- For each project whose first-draft delivery date (`初版` / `交初版` / equivalent current field) falls on a Monday-Friday in the target week, add the unchecked task `项目推进：{项目名}初版` on that exact date; for example, `项目推进：示例项目B初版`. Resolve the actual schedule fields on every run, merge duplicate rows, and use a newer explicit reschedule from project chat when present. If a trigger date is outside the five weekday rows, do not silently move it to another day.
- Treat packaging review and first-draft delivery as two distinct planned tasks. Keep both when they fall on the same date. The schedule proves the plan and timing only; it never proves completion.
- Rainbow's approved OKR-plan layout uses the three large objectives shown in the left OKR images, not individual KR headings. Use `O1拆解：保证项目产能稳定`, `O2拆解：AI`, and `O3拆解：育人`; map each confirmed weekly task to the objective that matches its actual intent. Do not emit `O1KR1`/`O2KR3`-style headings. A confirmed schedule item that does not credibly map to an objective may stay in the weekday plan without being forced into the OKR task area.
- The approved image and right-cell formatting reference for this large-O layout is `（从本地 source-profile.local.md 读取对应链接）` (`Rainbow工作周报（8.3-8.7）`). Treat it as read-only and fetch it fresh before migrating the three OKR images or the large-O heading styles.
- A current user instruction overrides these stored conventions.

## Personal completion-writing conventions

- During every daily closeout, proactively inspect Rainbow's Codex tasks active or updated that day. Include substantive project or AI work even when it was not mentioned in Feishu and Rainbow did not remind the agent. Exclude the weekly-report automation itself and unrelated tasks. A running task, interrupted attempt, or generated first draft is progress, not automatic completion.
- Let categories follow the day's actual work and Rainbow's current manual organization. Do not force `项目推进 / 育人 / AI`, a fixed order, or an empty category. A specific meeting may be its own category when the meeting produced a concrete decision or next action. Mirror the current target's user-edited heading style instead of assuming blue underlined headings.
- Use Rainbow's manually revised 2026-09-07 Monday completion cell in `Rainbow工作周报（9.7-9.11）` (`（从本地 source-profile.local.md 读取对应链接）`) as read-only daily-writing calibration. Re-fetch it when style comparison matters; newer user edits override this snapshot, and the document must never be modified merely to inspect or imitate the style.
- Start with the real work and let the thinking appear inside the same paragraph. Preferred flow: `工作对象 → 今天具体做了什么 → 结果到哪一步 → 当前判断或取舍 → 对大家怎么用 / 下一步`. Do not require every segment when the evidence does not support it.
- Preserve Rainbow's direct, conversational first-person voice. Phrases such as `目前的思路是`、`还没找到问题`、`先放弃`、`明天开启制作` are acceptable when accurate. Correct obvious typos, but do not sanitize the prose into official reporting language.
- For AI work, concrete iteration counts may establish real effort and status, but filenames, configuration fields, schemas, test harnesses, and validation receipts stay out of the visible report unless they explain the actual conclusion. State what now works, what is still being tested, and what criterion matters—for example, whether a shared visual reference improves information expression rather than merely looking polished.
- Write the team perspective as usability and coordination, not as an abstract “team lesson”: whether others can use the result as a reference, whether the workflow occupies their computer or interrupts work, what feedback should be accumulated, and when the team will review it together.
- For a failed experiment, say plainly what failed, the current partial capability, the practical inconvenience, and the decision to continue or stop. Do not turn the attempt into a completed achievement.
- Keep meeting and project updates short. For a meeting, record the decision plus the next feedback/action point. For a project, record the current production conditions and the next concrete start or delivery step.
- A checked daily task may coexist with remaining work on the larger initiative when Rainbow has manually marked the day's intended step complete. Preserve the manual state and make the remaining testing or follow-up explicit in prose; do not silently reinterpret it as whole-project completion.
- For ordinary project progress, do not expand every concrete edit into a long narrative. For animation projects, prefer `动画：分镜梳理{n}%+风格收集/制作包装{n}%+排版{n}%+动画{n}%`, using only percentages supported by current evidence, followed by a few concise sentences about the material bottleneck and current stage.
- Do not force reflection into every item. Use candid first-person reflection only for mistakes, rework, judgment errors, avoidable delays, blockers, or feedback-driven corrections. Normal progress can remain a direct status update.
- When reflection is warranted, say what was judged incorrectly, the real reason or impact, and the concrete correction. Avoid official closeout phrasing such as `接手并补齐`、`复核包装`、`推进优化`、`完成交付` when it obscures the actual state.

## Resolution rules

- Derive the current user's `open_id` from verified auth status; never store it here.
- Confirm the Base title, table ID, and field schema on every run because names and structures can change.
- Treat links labeled `本周排期`, `发布排期`, or equivalent in project chat as unresolved resources until their actual type is known.
- Prefer a target URL supplied in the current request. The target changes by week; never reuse a previous target automatically.
- Treat the canonical template as a read-only structural source. Fetch it with `--detail full` before creating or filling a report, and validate against [template-contract.md](template-contract.md).
- After validating the canonical contract, prefer copying the verified personal working master for Rainbow Monday plans. Confirm its title, three-column fingerprint, three images, large-O headings, five green placeholders, empty completion/review cells, empty summary content, and zero checked boxes. If any check fails, fall back to copying the canonical template and applying the personal large-O override.
- Never edit the style reference, schedule Base, or project group.
- Do not force historical categories onto a new template. Use `AI`, `流程与知识沉淀`, and `育人 / 项目支持` only when the current evidence and target structure support them.
