#! /bin/sh
#
# rm-if-gone: remove branches that have a configured upstream
# where the configured upstream no longer exists.  Run with
# -f to make it work, otherwise it just prints what it would
# remove.
force=false
case "$1" in
-f) force=true;;
esac

for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
    # find configured upstream, if any
    remote=$(git config --get branch.$branch.remote) || true
    # if tracking local branch, skip
    if [ "$remote" = . ]; then continue; fi
    # if the upstream commit resolves, skip
    ucommit=$(git rev-parse "${branch}@{u}" 2>/dev/null) && continue
    # upstream is invalid - remove local branch, or print removal
    $force && git branch -D $branch || echo "git branch -D $branch"
done
