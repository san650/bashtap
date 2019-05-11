#!/usr/bin/env bash

# TAP = Test Anything Protocol http://testanything.org/

TEST_INDEX="$1"
STATUS_EXIT=0
ACTUAL_OUTPUT_PATH=
TEST_COUNTER=0
CURRENT_TEST=
ACTUAL_OUTPUT=

function plan {
  # Count the numbers of `spec` calls in the file
  local TOTAL

  TOTAL=$(grep --count "^spec " "$0")

  if [ -n "$TEST_INDEX" ]; then
    TOTAL=1
  fi

  echo "1..${TOTAL}"
}

function cleanup {
  rm -rf "$ACTUAL_OUTPUT_PATH"
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
  echo "${3/#/#      }"
  echo "#"
  echo "#      ACTUAL:"
  echo "${4/#/#      }"

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
  if [ -n "$TEST_INDEX" ] && [ "$TEST_INDEX" != "$TEST_COUNTER" ]; then
    return
  fi

  ACTUAL_OUTPUT_PATH="$(mktemp -d -t bashtap-actual-output-XXXXXXX)"
  CURRENT_TEST="$1"
  ACTUAL_OUTPUT="$ACTUAL_OUTPUT_PATH/test-$TEST_COUNTER-actual-output"
}

function expect {
  local TEST

  TEST=$(cat)

  # If test index is set, skipt the test if it's not the right index
  # This allows to run one test at a time: `./test.sh 3`
  if [ -n "$TEST_INDEX" ] && [ "$TEST_INDEX" != "$TEST_COUNTER" ]; then
    return
  fi

  eval "$TEST" > "$ACTUAL_OUTPUT" 2>&1
}

function to_output {
  local EXPECTED
  local ACTUAL
  local NUMBER

  EXPECTED=$(cat)
  ACTUAL=$(cat "$ACTUAL_OUTPUT")
  NUMBER=${TEST_COUNTER}

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
