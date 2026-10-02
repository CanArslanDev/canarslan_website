#!/usr/bin/env bash
# Builds the real site and publishes it as the deploy repository's only commit.
#
#   tool/deploy.sh "what changed"
#
# The deploy repository (CanArslanDev.github.io, served by GitHub Pages from
# main) is public, and every commit it ever had stays downloadable. That
# matters for one file: web/vault.json. A vault replaced in an ordinary commit
# is still there in the one before it — sealed under whatever codes it had
# then, and open to the same offline guessing as the current one. Rotating a
# code or removing a page would change nothing for anyone reading history.
#
# So there is no history. Each deploy is an orphan commit force-pushed over
# main, and the local clone forgets the old ones too. The site is a build
# artifact; the source history lives in this repository, where it belongs.
#
# Built from lib/main_private.dart, because that is the entrypoint carrying the
# private pages — deploying lib/main.dart would quietly empty the vault's room.

set -euo pipefail

message="${1:?usage: tool/deploy.sh \"what changed\"}"

root="$(cd "$(dirname "$0")/.." && pwd)"
deploy="${DEPLOY_REPO:-$root/../CanArslanDev.github.io}"
web="$root/build/web"

fail() {
  echo "deploy: $*" >&2
  exit 1
}

[[ -f "$root/lib/main_private.dart" ]] ||
  fail "lib/main_private.dart is missing; the private pages would not ship"
[[ -f "$root/web/vault.json" ]] ||
  fail "web/vault.json is missing; run tool/vault.js first"
[[ -d "$deploy/.git" ]] || fail "no deploy repository at $deploy"
[[ -z "$(git -C "$deploy" status --porcelain)" ]] ||
  fail "$deploy has uncommitted changes"

(cd "$root" && flutter build web --release -t lib/main_private.dart)

# A source map would hand the private pages' Dart source to anyone who asked.
if [[ -n "$(find "$web" -name '*.map' -print -quit)" ]]; then
  fail "the build contains source maps; refusing to publish them"
fi

cd "$deploy"
git checkout -q --orphan deploy-next
git rm -rq --cached . >/dev/null
git clean -fdxq
rsync -a --exclude .git "$web/" ./
git add -A
git commit -qm "Deploy: $message"
git branch -M deploy-next main
git push -q --force origin main

# Drop the old commits from this clone too, so nothing here can be pushed back.
git reflog expire --expire=now --all
git gc -q --prune=now

echo "deployed $(git rev-parse --short HEAD) — $(git rev-list --count HEAD) commit"
