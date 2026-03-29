---
description: Create, update, or comment on GitHub issues using gh CLI
---

Upserts a GitHub issue using the `gh` CLI. Creates a new issue if it doesn't exist, or updates/comments on an existing one.

## Arguments

$ARGUMENTS — GitHub issue number (e.g., `#123` or `123`)

## Steps

1. **Parse issue number**
   - Extract number from $ARGUMENTS (handle `#123` or `123`)
   - If missing or invalid: Ask user for the issue number

2. **Check if issue exists**
   - Run: !`gh issue view <issue-number>`
   - Capture title, body, and state
   - Non-zero exit code = issue doesn't exist

3. **Extract content from conversation**
   - Review history for title (short phrase) and body (detailed description)
   - If ambiguous or missing: Ask user to clarify

4. **Handle based on issue status**

   **Issue does NOT exist:**
   - Ask: "Issue #123 doesn't exist. Create it? (yes/no)"
   - If yes: Run !`gh issue create --title "<title>" --body "<body>"` and show the URL
   - If no: Exit

   **Issue EXISTS:**
   - Ask: "Issue #123 exists. Choose action:
     1. Update (title/body)
     2. Add comment
     3. Cancel"

   **Update selected:**
   - Run !`gh issue view <issue-number>` to show current details
   - Display diff showing proposed changes
   - Ask: "1. Apply changes  2. Add comment instead  3. Cancel"
   - If approve: Run !`gh issue edit <issue-number> --title "<title>" --body "<body>"` then !`gh issue view <issue-number>`
   - If comment: Run !`gh issue comment <issue-number> --body "<body>"` and confirm
   - If cancel: Exit

   **Comment selected:**
   - Run !`gh issue comment <issue-number> --body "<body>"` and confirm

   **Cancel:** Exit

5. **Error handling**
   - gh not installed: Run !`which gh`, inform user and suggest installation
   - Not in git repo: Run !`git rev-parse --git-dir`, ask to run from repo directory
   - Auth failure: Prompt to run !`gh auth login`
   - Rate limited: Inform user and retry after delay

6. **Summary**
   - Display action taken (created/updated/commented)
   - Show issue number, title, and URL via !`gh issue view <issue-number> --json url -q '.url'`
   - If commented, show comment preview

## Examples

### Update existing issue
- User: `/ghi-upsert #42`
- Command: !`gh issue view 42` — issue exists
- User chooses update
- Command shows current issue and diff of proposed changes
- User approves
- Command: !`gh issue edit 42 --title "New Title" --body "New Body"`
- Result: "Updated issue #42: https://github.com/user/repo/issues/42"

### Create new issue
- User: `/ghi-upsert #999`
- Command: !`gh issue view 999` — issue not found
- User confirms creation
- Command: !`gh issue create --title "Title" --body "Body"`
- Result: "Created issue #999: https://github.com/user/repo/issues/999"

### Add comment to issue
- User: `/ghi-upsert 42`
- Command: !`gh issue view 42` — issue exists
- User chooses comment
- Command: !`gh issue comment 42 --body "Comment text"`
- Result: "Added comment to issue #42: https://github.com/user/repo/issues/42"
