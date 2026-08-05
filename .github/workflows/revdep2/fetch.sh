#!/bin/sh
# Fetch the results of a revdep2 run into revdep/ and show the summary.
#
# Usage:
#   .github/workflows/revdep2/fetch.sh [<run-id>] [<dir>]
#
# Without a run id, the newest completed revdep2 run of the current repository
# is used. Needs the `gh` CLI, authenticated for the repository.

set -eu

run="${1:-}"
dir="${2:-revdep}"

if [ -z "${run}" ]; then
  run="$(gh run list --workflow revdep2.yaml --limit 20 \
    --json databaseId,status --jq \
    '[.[] | select(.status == "completed")][0].databaseId')"
  if [ -z "${run}" ] || [ "${run}" = "null" ]; then
    echo "No completed revdep2 run found; pass a run id." >&2
    exit 1
  fi
  echo "Using newest completed revdep2 run: ${run}"
fi

mkdir -p "${dir}"
gh run download "${run}" --name revdep2-report --dir "${dir}"

echo
echo "Results of run ${run} are in ${dir}/:"
ls "${dir}"
echo
if [ -f "${dir}/README.md" ]; then
  cat "${dir}/README.md"
fi
echo
echo "To re-check everything that is not ok:"
echo "  gh workflow run revdep2.yaml -f retry-run=${run}"
