#!/usr/bin/env bash
#
# publish.sh: tests the core, builds it and publishes it as com.embergabor:simplex-core:<version> into a
# checkout of github.com/embergabor/simplex-maven next to this one, then commits it there and tags this
# repo. GitHub serves that repo as plain files, so the apps fetch the core from it like any library.
#
# Needs: JDK 17+, the Android SDK, a clean checkout here and ../simplex-maven.
#
# Usage: tools/publish.sh <version> [--push]
#   --push  also pushes the tag here and the new files in simplex-maven.

set -euo pipefail
cd "$(dirname "$0")/.."

version=${1:?Usage: tools/publish.sh <version> [--push]}
push=${2:-}
maven=../simplex-maven

[ -d "$maven/.git" ] || { echo "No simplex-maven checkout at $maven" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "Commit or stash your changes first." >&2; exit 1; }
! git rev-parse -q --verify "refs/tags/v$version" >/dev/null || { echo "v$version is already published." >&2; exit 1; }

./gradlew -q :core:testDebugUnitTest
./gradlew -q :core:publishReleasePublicationToSimplexMavenRepository -PcoreVersion="$version" -PsimplexMaven="$(cd "$maven" && pwd)"

git tag "v$version"
git -C "$maven" add com
git -C "$maven" commit -q -m "simplex-core $version"
echo "Published simplex-core $version into $maven."

if [ "$push" = "--push" ]; then
    git push -q origin "v$version"
    git -C "$maven" push -q
    echo "Pushed. Apps can use com.embergabor:simplex-core:$version."
else
    echo "Not pushed: git push origin v$version, and git -C $maven push."
fi
