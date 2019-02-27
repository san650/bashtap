#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
