#!/bin/bash

[ -n "$(which x11docker)" ] \
    || { echo "x11docker is required"; exit 1; }

CMD=${@}
[ -n "${CMD}" ] \
    || { echo "Command is required"; exit 1; }

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
PROJECT_DIR=$(dirname ${SCRIPT_DIR})
IMAGE='chak-chak:1.0'

[ -n "$(docker images -q --filter=reference="${IMAGE}")" ] \
    || docker build -t "${IMAGE}" ${SCRIPT_DIR}

x11docker --hostdisplay --homedir ${HOME} --clipboard --stdout --stderr \
    --cap-default \
    --workdir ${PROJECT_DIR} \
    -- "--cap-add=SYS_PTRACE" \
    "${IMAGE}" \
    ${CMD}
