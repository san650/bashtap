#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${PWD}/../../bashtap.bash"

plan

spec "first test"
expect << EOT
echo hello
EOT
to_output << EOT
hello
EOT

spec "second test"
expect << EOT
echo hello
EOT
to_output << EOT
world
EOT

spec "third test"
expect << EOT
echo hello
EOT
to_output << EOT
hello
EOT

finish
