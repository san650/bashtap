#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=bashtap.bash
source "${PWD}/../bashtap.bash"

plan

spec "green test suite"
expect << EOT
"$PWD/fixtures/green.sh"
EOT
to_output << EOT
1..1
ok 1 echo does what it does
EOT

spec "red test suite"
expect << EOT
"$PWD/fixtures/red.sh"
EOT
to_output << EOT
1..1
not ok 1 fails
#      EXPECTED:
#      this is not a hello world
#
#      ACTUAL:
#      hello world
EOT

spec "red test suite"
expect << EOT
"$PWD/fixtures/complex.sh"
EOT
to_output << EOT
1..3
ok 1 first test
not ok 2 second test
#      EXPECTED:
#      world
#
#      ACTUAL:
#      hello
ok 3 third test
EOT

spec "using string"
expect <<< 'echo hello world'
to_output <<< 'hello world'

finish
