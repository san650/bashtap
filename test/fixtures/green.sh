#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=bashtap.bash
source "${PWD}/../../bashtap.bash"

plan

spec "echo does what it does"
expect << EOT
echo hello world
EOT
to_output << EOT
hello world
EOT

finish
