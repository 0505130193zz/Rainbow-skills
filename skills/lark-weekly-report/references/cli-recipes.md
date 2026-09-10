# Lark CLI recipes for weekly reports

Treat the version-matched embedded Lark skills as the command source of truth. Use these recipes for weekly-report orchestration and Windows-safe capture.

## Windows UTF-8 and clean JSON

Initialize each PowerShell session before a machine-readable CLI call:

```powershell
$Utf8NoBom = [Text.UTF8Encoding]::new($false)
$OutputEncoding = [Console]::OutputEncoding = $Utf8NoBom
$env:LARKSUITE_CLI_NO_UPDATE_NOTIFIER = '1'
$env:LARKSUITE_CLI_NO_SKILLS_NOTIFIER = '1'
```

Do not read UTF-8 JSON with bare `Get-Content` in Windows PowerShell 5.1; it may decode a valid no-BOM file using the legacy code page. Use explicit UTF-8:

```powershell
$raw = [IO.File]::ReadAllText((Resolve-Path '.\weekly_report_data\messages.json'), [Text.Encoding]::UTF8)
$result = $raw | ConvertFrom-Json -ErrorAction Stop
```

Write captured JSON explicitly as UTF-8 without BOM:

```powershell
$raw = (& lark-cli im +messages-search <args> --as user --format json | Out-String)
if ($LASTEXITCODE -ne 0) { throw "lark-cli failed with exit code $LASTEXITCODE" }
$result = $raw | ConvertFrom-Json -ErrorAction Stop
if ($result.ok -ne $true) { throw 'Lark API envelope is not successful' }
[IO.File]::WriteAllText('.\weekly_report_data\messages.json', $raw, $Utf8NoBom)
```

Use only relative `@file`, `--output`, and `--output-dir` paths under the current working directory. Never store tokens, authorization URLs, or device codes in reusable evidence files.

## Repeatable preflight

From the skill directory or by using its absolute installed path. On Windows PowerShell 5.1, use a process-local execution-policy bypass so the command does not change the machine policy:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File '.\scripts\preflight.ps1' -CliPath 'lark-cli'
```

Validate multiple existing captures from an already-running PowerShell process:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command `
  "& '.\scripts\preflight.ps1' -CliPath 'lark-cli' -JsonPath @('.\weekly_report_data\messages.json','.\weekly_report_data\target.json')"
```

The script prints only a minimal status summary; it does not expose the user's open ID or scope list.

## Identity and time range

```powershell
lark-cli auth status --json --verify
```

Require `verified=true` and `identities.user.available=true`. A user status of `needs_refresh` is usable when verification succeeded. Derive the current `open_id` from this response without copying it into the skill.

Compute ISO 8601 boundaries with the `+08:00` offset. Record the resolved dates before querying.

For Monday planning, compute two different ranges:

- evidence: previous Monday `00:00:00+08:00` through previous Sunday `23:59:59+08:00`;
- target: current Monday through Friday.

Run message search against the evidence range. Do not use Monday 00:00 through the current time as the evidence range for a Monday plan.

## User-authored activity

Use an empty semantic query and filter by the verified sender ID and time range:

```powershell
lark-cli im +messages-search `
  --query '' `
  --sender '<my_open_id>' `
  --start '<start+08:00>' `
  --end '<end+08:00>' `
  --page-size 50 --page-all --no-reactions `
  --as user --format json
```

Accumulate all results before summarizing. If the auto-pagination cap is reached and `has_more=true`, continue with the returned page token. Exclude deleted messages and treat edited messages according to their current content while retaining the edit time internally.

For Monday planning, record a coverage receipt before drafting:

```text
source=authored_messages | start=<previous Monday> | end=<previous Sunday> | pages=<n> | has_more=false
```

Do not draft or write the weekly plan without `has_more=false` for the complete previous-week range.

Resolve material links or attachments only when they support a report claim. Do not download every attachment by default.

## Project group and threads

```powershell
lark-cli im +chat-search --query '项目沟通' --page-size 50 --as user --format json

lark-cli im +chat-messages-list `
  --chat-id '<resolved_chat_id>' `
  --start '<start+08:00>' `
  --end '<end+08:00>' `
  --order asc --page-size 50 `
  --as user --format json
```

Paginate until complete. Read a thread when a relevant message exposes `thread_id` and the assignment, decision, feedback, or schedule change depends on its replies. Do not load unrelated group history.

## Schedule Base

Resolve the Wiki resource before querying, then inspect the actual table and field schema:

```powershell
lark-cli base +url-resolve --url '<schedule_wiki_url>' --as user --format json
lark-cli base +table-list --base-token '<base_token>' --as user --format json
lark-cli base +field-list --base-token '<base_token>' --table-id '<table_id>' --as user --format json
```

Build filters from current field names/IDs. Filter the project-member field by the verified user's `open_id`; add a month/date filter only after checking the field's real type and values. Use an `@file` JSON payload to avoid PowerShell quoting errors.

Project only fields needed for ownership, status, timing, and explanation. Prefer cloud-side filtering. For row-level conclusions, use record-list/search and handle `has_more`; do not treat aggregated `+data-query` output as individual records.

## Style sample and target

Keep the resources distinct:

```powershell
lark-cli docs +fetch --doc '<style_report_url>' `
  --detail simple --doc-format xml --as user --format json

lark-cli docs +fetch --doc '<target_url>' `
  --detail full --doc-format xml --as user --format json
```

Use `simple` for style calibration. Use `outline`, `keyword`, `section`, or `range` to narrow ordinary document reads. A full weekly-report table edit justifies `--detail full`; fetch it immediately before writing so block IDs, styles, and revision are current.

## Comments and locations

For a Wiki target, resolve the underlying docx token. List unsolved comments with relations and paginate:

```json
{
  "file_token": "<docx_token>",
  "file_type": "docx",
  "is_solved": false,
  "need_relation": true,
  "page_size": 100,
  "user_id_type": "open_id"
}
```

```powershell
lark-cli drive file.comments list `
  --params '@comment_params.json' --as user --format json
```

Parse `relation.relation` as nested JSON and map `positionInfo.blockID` to a current `docs +fetch --detail with-ids/full` result. Use `parent_type` and `parent_token` to locate embedded resources. Use quote matching only as labeled inference.

## Fast read-only orchestration

- Start independent authored-message, project-chat, Base, and path/template reads concurrently, capped at four active CLI processes. Never parallelize pagination pages that depend on a previous page token.
- Use each command's maximum supported page size and write a coverage receipt per source: resolved range, page count, item count, and final `has_more`.
- Validate UTF-8, JSON, exit code, and `ok == true` immediately after each capture. At the end, validate the receipt manifest plus new write/final-fetch captures instead of rereading every immutable page.
- Cache resolved space/month/Base locators in automation memory as non-authoritative hints. Confirm title, type, parent, and expected schema before reuse; rediscover fully on mismatch.

## Safe updates

- Put non-trivial XML in a relative payload file.
- Prepare every payload before the first write so evidence analysis and XML generation do not interrupt the revision chain.
- When [source-profile.md](source-profile.md) names a verified personal working master, fetch the canonical template once for the contract, validate the working master fingerprint, and copy the working master. Fall back to the canonical copy path if validation fails.
- Preserve the target's current revision ID and pass it when the command supports revision checks.
- Prefer `str_replace`, `block_replace`, `block_insert_after`, `block_delete`, or `block_move_after` on the smallest affected blocks.
- Avoid `overwrite`; do not replace the report document merely to fill a table.
- Run `--dry-run` for structural updates and inspect the request before execution.
- Execute writes sequentially.
- Re-fetch after `block_replace`, `block_delete`, or any operation that invalidates or relocates IDs. Prefer a `range`/`keyword` fetch containing the remaining target cells; use `full` only when global structure or styles must be re-established.
- Use comma-separated `block_delete` for independent stale blocks discovered in the same current revision.
- Inspect `result`, `updated_blocks_count`, `warnings`, and the returned revision after every write.
- Perform one final `--detail full` acceptance fetch. Re-read full source templates or historical reports only when their revision changed; otherwise use the write-target ledger plus revision equality.
- Never add `--yes` after exit code 10 without the user's explicit approval of the reported high-risk action.

Example:

```powershell
lark-cli docs +update --doc '<target_url>' `
  --command block_replace --block-id '<block_id>' `
  --content '@payload.xml' --doc-format xml `
  --revision-id '<current_revision>' `
  --as user --dry-run --format json
```

Re-run without `--dry-run` only after the preview matches the intended block.

## Failure handling

- On `missing` or `not_configured` from a restricted environment, repeat auth verification in the host environment before asking the user to reauthorize.
- On missing user scope, follow `lark-shared` split-flow authorization; never silently switch to bot.
- On a Wiki/Base/document mismatch, resolve the resource type instead of guessing.
- On JSON parse or mojibake detection, stop and repeat the capture with explicit UTF-8; do not analyze corrupted text.
- On a stale revision or invalid block ID, re-fetch and re-plan the remaining writes.
- On comment relation absence, label quote-based matching as inference.
- Never expose tokens, secrets, private IDs, raw private messages, or authorization data in the final response.
