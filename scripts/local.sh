#!/usr/bin/env bash

MODE="${1}"
TECH_DOCS_PUBLISHER_IMAGE="docker.io/ministryofjustice/tech-docs-github-pages-publisher:v3.0.2"

case ${MODE} in
deploy | preview | check-url-links)
  true
  ;;
*)
  echo "Usage: ${0} [deploy|preview|check-url-links]"
  exit 1
  ;;
esac

if [[ "$(uname -m)" == "aarch64" ]] || [[ "$(uname -m)" == "arm64" ]]; then
  PLATFORM_FLAG="--platform linux/amd64"
else
  PLATFORM_FLAG=""
fi

docker run -it --rm "${PLATFORM_FLAG}" \
  --name "tech-docs-${MODE}" \
  --publish 4567:4567 \
  --volume "${PWD}/config:/app/config" \
  --volume "${PWD}/source:/app/source" \
  "${TECH_DOCS_PUBLISHER_IMAGE}" "/scripts/${MODE}.sh"