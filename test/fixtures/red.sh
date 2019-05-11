#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=bashtap.bash
source "${PWD}/../../bashtap.bash"

plan

spec "fails"
expect << EOT
echo hello world
EOT
to_output << EOT
this is not a hello world
EOT

finish
