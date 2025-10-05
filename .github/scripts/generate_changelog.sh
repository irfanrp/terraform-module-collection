#!/usr/bin/env bash
set -euo pipefail
# Simple changelog generator for modules/examples changes
# Usage: generate_changelog.sh <TAG> [output_file]

TAG=${1:-}
OUT=${2:-/tmp/new_changelog.md}
REPO=${GITHUB_REPOSITORY:-$(git config --get remote.origin.url | sed -n 's#.*/\([^/]*\/[^/.]*\)\(.git\)?#\1#p' || true)}

if [ -z "$TAG" ]; then
  echo "Usage: $0 <tag> [outfile]" >&2
  exit 1
fi

PREV_TAG=$(git tag --sort=-creatordate | grep -v "^$TAG$" | head -n1 || true)
if [ -z "$PREV_TAG" ]; then
  RANGE="$TAG"
else
  RANGE="$PREV_TAG..$TAG"
fi

echo "## ${TAG} - $(date -u +%Y-%m-%d)" > "$OUT"
echo >> "$OUT"

ADDED=/tmp/ch_added.txt
CHANGED=/tmp/ch_changed.txt
FIXED=/tmp/ch_fixed.txt
DOCS=/tmp/ch_docs.txt
SEC=/tmp/ch_security.txt
: > $ADDED; : > $CHANGED; : > $FIXED; : > $DOCS; : > $SEC

# Collect commits in range but only those touching modules/ or examples/
COMMITS=$(git rev-list --reverse ${RANGE} -- modules/ examples/ || true)

for c in $COMMITS; do
  files=$(git diff-tree --no-commit-id --name-only -r $c || true)
  if ! echo "$files" | grep -qE '^(modules/|examples/)'; then
    continue
  fi
  subject=$(git show -s --format='%s' $c)
  # Try to extract PR number from merge body or subject
  prnum=$(git show -s --format='%b' $c | grep -oE 'Merge pull request #[0-9]+' | sed -E 's/.*#([0-9]+).*/\1/' || true)
  if [ -z "$prnum" ]; then
    prnum=$(echo "$subject" | grep -oE '\(#[0-9]+\)|#[0-9]+' | head -n1 || true)
    prnum=$(echo "$prnum" | tr -d '()#')
  fi
  if [ -n "$prnum" ]; then
    prlink=" ([#${prnum}](https://github.com/${REPO}/pull/${prnum}))"
    subject=$(echo "$subject" | sed -E 's/ ?\(?#?[0-9]+\)?$//')
  else
    prlink=""
  fi
  line="- ${subject}${prlink}"
  lc=$(echo "$subject" | awk '{print tolower($0)}')
  if echo "$lc" | grep -qE '^feat|^feature'; then
    echo "$line" >> $ADDED
  elif echo "$lc" | grep -qE '^fix|^bugfix'; then
    echo "$line" >> $FIXED
  elif echo "$lc" | grep -qE '^docs|^documentation'; then
    echo "$line" >> $DOCS
  elif echo "$lc" | grep -qE '^security|^sec'; then
    echo "$line" >> $SEC
  elif echo "$lc" | grep -qE '^chore|^refactor|^perf|^ci|^build|^style|^test|^change'; then
    echo "$line" >> $CHANGED
  else
    # Skip uncategorized / generic changes (do not include an 'Other' section)
    continue
  fi
done

if [ -s $ADDED ]; then echo "### Added" >> "$OUT"; sort -u $ADDED >> "$OUT"; echo >> "$OUT"; fi
if [ -s $CHANGED ]; then echo "### Changed" >> "$OUT"; sort -u $CHANGED >> "$OUT"; echo >> "$OUT"; fi
if [ -s $FIXED ]; then echo "### Fixed" >> "$OUT"; sort -u $FIXED >> "$OUT"; echo >> "$OUT"; fi
if [ -s $DOCS ]; then echo "### Docs" >> "$OUT"; sort -u $DOCS >> "$OUT"; echo >> "$OUT"; fi
if [ -s $SEC ]; then echo "### Security" >> "$OUT"; sort -u $SEC >> "$OUT"; echo >> "$OUT"; fi
# 'Other' section intentionally omitted to keep changelog focused

echo >> "$OUT"
if [ -n "$PREV_TAG" ]; then
  echo "[${PREV_TAG}...${TAG}]: https://github.com/${REPO}/compare/${PREV_TAG}...${TAG}" >> "$OUT"
fi
echo "[${TAG}]: https://github.com/${REPO}/releases/tag/${TAG}" >> "$OUT"

echo "$OUT"
