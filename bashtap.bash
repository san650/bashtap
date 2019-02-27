# TAP = Test Anything Protocol http://testanything.org/

TEST_INDEX="$1"
STATUS_EXIT=0
TODO_DB_PATH=
TMP_OUTPUT=
TODO="$(pwd)/bin/todo"
TEST_COUNTER=0
CURRENT_TEST=
EXPECTED_OUTPUT=
ACTUAL_OUTPUT_FILE_FILE=

function plan {
  # Count the numbers of `spec` calls in the file
  local TOTAL=$(grep --count "^spec " "$0")

  if [ -n "$TEST_INDEX" ]; then
    TOTAL=1
  fi

  echo "1..${TOTAL}"
}

function cleanup {
  rm -rf "$TODO_DB_PATH"
  rm -rf "$TMP_OUTPUT"
}

trap cleanup EXIT

function tap_ok()
{
  echo "ok $1 $2"
}

function tap_not_ok()
{
  echo "not ok $1 $2"

  # print diagnostics
  echo "#      EXPECTED:"
  echo "$3" | sed 's/^/#      /'
  echo "#"
  echo "#      ACTUAL:"
  echo "$4" | sed 's/^/#      /'

  STATUS_EXIT=1
}

function finish()
{
  exit $STATUS_EXIT
}

function spec {
  ((TEST_COUNTER++))

  # If test index is set, skipt the test if it's not the right index
  # This allows to run one test at a time: `./test.sh 3`
  if [ -n "$TEST_INDEX" -a "$TEST_INDEX" != "$TEST_COUNTER" ]; then
    return
  fi

  TODO_DB_PATH=$(mktemp -d -t todo-test-XXXXXXX)
  TMP_OUTPUT="$(mktemp -d -t todo-test-output-XXXXXXX)/output"
  CURRENT_TEST="$1"
  EXPECTED_OUTPUT="$TODO_DB_PATH/test-$TEST_COUNTER-expected-output"
  ACTUAL_OUTPUT_FILE_FILE="$TMP_OUTPUT/test-$TEST_COUNTER-actual-output"
  mkdir -p "$TMP_OUTPUT"
}

function expect {
  local TEST=$(cat)

  # If test index is set, skipt the test if it's not the right index
  # This allows to run one test at a time: `./test.sh 3`
  if [ -n "$TEST_INDEX" -a "$TEST_INDEX" != "$TEST_COUNTER" ]; then
    return
  fi

  # Cleanup all variables before running a test
  TODO_PATH=
  TODO_PROJECT=
  TODO_FILTER=

  eval "$TEST" 2>&1 > $ACTUAL_OUTPUT_FILE_FILE
}

function to_output {
  local EXPECTED=$(cat)
  local ACTUAL=$(cat $ACTUAL_OUTPUT_FILE_FILE)
  local NUMBER=${TEST_COUNTER}

  # If test index is set, skipt the test if it's not the right index
  # This allows to run one test at a time: `./test.sh 3`
  if [ -n "$TEST_INDEX" ]; then
    if [ "$TEST_INDEX" != "$TEST_COUNTER" ]; then
      return
    fi

    # if test index is defined, only one test is going to run
    NUMBER=1
  fi

  if [ "$EXPECTED" == "$ACTUAL" ]; then
    tap_ok "$NUMBER" "$CURRENT_TEST"
  else
    tap_not_ok "$NUMBER" "$CURRENT_TEST" "$EXPECTED" "$ACTUAL"
  fi
}
