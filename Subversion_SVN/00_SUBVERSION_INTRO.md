# Subversion (SVN)

The biggest difference between Git + BitBucket and SVN is that
Subversion is centralized: the repository is the single source
of truth, and your local folder is a working copy, not
a full local repository with its own commit history.

## Central SVN Concepts

- **Repository** -> the server (central history). In SVN, each
commit creates a new global revision number for the
repository state.

- **Working Copy** -> Your local folder that contains a snapshot
of the code + SVN metadata. You edit files here, then you
"commit" to the server.

- Update vs Commit:
    - **Update** -> Brings others' changes from the server
    into your working copy (similar to `git pull`, without
    without the `fetch` + `merge` separation).
    - **Commit** -> sends your changes from your working copy
    to the central repository.

- SVN also supports familiar git features, but implemented
differently:
    - Atomic commits (either all changes go in, or none).
    - Directories are versioned like files.
    - Properties (metadata) on files/folders (key/value,
    versioned)
    - File locking (useful for binaries that don't merge well).

## Standard SVN Repository Structure

Most teams use the "classic" structure:

- `/trunk` -> main line of development.
- `/branches` -> long-lived or short-lived branches.
- `/tags` -> release snapshots.

SVN does not have special branch/tag objects. Instead,
branches/tags are created as "cheap copies", i.e., a copy
operation in the repository that is 
**fast** and **space-efficient**.

The SVN Book explains why teams branch: it lets you isolate
large changes so you don't break the main line
while still committing incremental progress.

## TortoiseSVN Basics

TortoiseSVN integrates into Windows Explorer (right-click
menus + icon overlays).

### Diff (what changed)

TortoiseSVN supports:
- `Diff` for local changes in your working copy.
- `Diff with URL` to compare your local file to another
branch or tag or trunk.
- Compare revisions, unified diff, etc.

Translation with Git:
- `git diff` = `Diff`
- `git diff branchA branch B` = `Diff with URL/Compare revisions`

### Blame/Annotate

TortoiseSVN's Blame shows for each line the author + revision
when it was last changed, and it can include merge info
(at some cost). Git translation:

- `git blame` = `Blame ...`

### Branching and Tagging in TortoiseSVN

If your repo follows `/trunk`, `/branches`, `/tags`,
TortoiseSVN makes it straightforward:
- Right-click the folder > TortoiseSVN > Branch/Tag
- Edit the destination URL (e.g. from `/trunk` to
`/tags/Release_1.10`)
- Note: intermediate folders must exist unless you check
"Create intermediate folders".

Git translation:

- `git checkout -b feature/x` 
= Create `/branches/feature-x` (cheap-copy)
- `git tag v1.10` = Create `tags/Release_1.10` (cheap-copy)

**Key point**: in SVN, a tag is just a copy. Many
organizations treat `/tags` as "write-once" by policy
(that policy is org-specific; the mechanism is the
cheap copy described above).

(How does my team manage `locks` and `merges`???)

## Merging in SVN (Where Git users get tripped up)

Tortoise SVN is explicit about two crucial rules:

1. Merging always takes place within a working copy: you
need a working copy of the target branch checked out, then
run the merge wizard from there.
2. It's recommended to merge into an unmodified working copy;
otherwise "Revert" may discard both the merge result and
any pre-existing local changes.

TortoiseSVN's merge wizard supports common cases like:
- **Merge a range of revisions** (port selected changes
across branches).
- Letting merge-tracking compute the range if you leave it
emoty (automatic/reintegrate style).

Git translation:
- `git merge feature/x` = "Merge..." in a working copy of
`/trunk` (or your target branch).
- `git cherry-pick <commit>` = "Merge a range of revisions"
(range of revisions = changesets).

| GIT  |  SVN   |
| :--- | :--- |
| `git status` | Tortoise overlays + "Check for modifications" view in commit dialog |
| `git diff` | TortoiseSVN > Diff |
| `git log` | Show Log on a folder/file |
| `git pull` | SVN Update |
| `git commit + git push` | SVN Commit |
| `git checkout -b` | Branch/Tag... to `/branches/...`|
| `git tag v2` | Branch/Tag... to `/tags/...` |
| `git merge/git cherry` | Merge... (in the target working copy prefer clean WC) |
| `git blame` | Blame... |