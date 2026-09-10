# Rainbow weekly-report template contract

## Authority

Use templates in this order:

1. A template URL explicitly supplied by the user in the current request.
2. The canonical read-only template: `（从本地 source-profile.local.md 读取对应链接）`.
3. A verified exact-format copy in the target month's weekly-report directory.

Historical reports may guide wording, but they do not override the selected template's structure. Never edit the canonical template.

For Rainbow Monday plans, the canonical template remains the contract source, while the verified personal working master in [source-profile.md](source-profile.md) is the preferred operational copy source. Fetch the canonical template once with `--detail full`, then validate the working master against this contract and the large-O override. If valid, copy it and replace every mutable task region; this avoids repeating image migration and KR-to-large-O reconstruction. Never edit either source. Fall back to the canonical template when the working master is absent, ambiguous, checked, structurally stale, or contains completion/summary text.

The exact fingerprint below applies to the Rainbow template only. If the user supplies another template, derive and verify its actual structure instead. Never reshape that template to fit these dimensions.

## Structural fingerprint

Fetch the selected template with `docs +fetch --detail full --doc-format xml` and preserve:

- one title followed by one main table;
- exactly three columns with widths `81 / 316 / 536`;
- the `上周遗留待办` header and its full-width content row;
- the `本周工作计划` header;
- the left OKR visual cell spanning two columns and two rows, including all three images;
- the right `本周任务（OKR 拆解）` cell, confirmed KR headings, highlight colors, and task-line style;
- the `日期 / 逐日待办及完成情况 / 完成情况及未完成原因/复盘` header row;
- all five weekday rows, their task checkboxes, the green `临时需求` checkbox, and the empty third-column completion/review cell;
- the `本周总结（下周待办）` header row and the following full-width content row.

Do not create an alternative two-column layout, remove the third column, assign tasks that are not confirmed for the current week, replace the OKR images with prose, or delete the summary section merely because its content must stay empty.

## Monday-plan filling rules

- Put unfinished carryover only in `上周遗留待办`.
- Put confirmed current-week work in the appropriate OKR task area; do not invent or rename KR headings.
- For Rainbow, apply the large-O personal override from `source-profile.md`: preserve the canonical table, widths, merged OKR image cell, weekday rows, completion column, temporary-request placeholders, and summary rows, while replacing the right-cell KR ladder with the approved `O1/O2/O3` grouping and its highlight style. Derive task placement from the current left OKR images and confirmed work; do not copy stale tasks from the formatting reference.
- Apply confirmed recurring tasks from `source-profile.md` and lock them to their fixed weekday unless the user explicitly cancels or reschedules them.
- Lock explicit dates, deadlines, meetings, and schedule rows to their supported weekdays.
- Place other confirmed current-week tasks into weekday rows by dependencies, execution order, and reasonable workload balance. This placement is a plan, not a claimed hard deadline.
- Keep checkbox wording scan-friendly, normally `类别：对象/主题`; do not copy evidence narratives or invented daily execution steps into the visible task label.
- Do not leave Monday or Tuesday blank solely because confirmed work lacks explicit dates, and do not fabricate work to fill a row.
- Leave every current-week checkbox unchecked.
- Leave every completion/review cell empty.
- Preserve the weekly-summary header and leave its content row empty.
- Preserve the green `临时需求` placeholder.
- Change only the title/date and intended task text. The default title is `Rainbow工作周报（M.D-M.D）`; do not add `【测试】` or any other test marker unless the user explicitly requests a test document in the current request.

## Write and verification

Prefer copying the exact template when supported. If a new target must be reconstructed, reproduce the fingerprint before filling content. For an existing target, use the smallest block-level XML edits; replacing the main table is acceptable only when the user explicitly asks to correct an entirely wrong layout.

Before the write, fetch the target at `--detail full`, pass its current revision, and dry-run structural changes. After the write, re-fetch and verify:

- column widths are exactly `81 / 316 / 536`;
- there are three OKR images;
- all five weekdays, the completion/review header, and the weekly-summary header/content row exist;
- in Monday-plan mode, all current-week checkboxes are unchecked; in closeout mode, completion states match evidence and current manual edits;
- in Monday-plan mode, completion/review cells and weekly-summary content are empty; in closeout mode, only the authorized day or summary region is updated;
- no unrelated block or the canonical template was modified.
- the title contains no test marker unless the current request explicitly asked for one.

After block-ID-invalidating writes, a scoped `range`/`keyword` fetch is sufficient for locating the next mutable cells when the untouched global fingerprint is already established. Always finish with one full acceptance fetch. When the working master was copied and its three image blocks remain unchanged, image existence and token/structure checks are sufficient; download and hash image binaries only after migration or reconstruction.
