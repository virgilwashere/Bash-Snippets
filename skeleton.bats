#!/usr/bin/env bats

export TOOL_NAME='skeleton'

setup() {
  # $REPO_DIR/tests/skeleton.bats
  REPO_DIR="$( cd "$( dirname "${BATS_TEST_DIRNAME}")" >/dev/null 2>&1 && pwd)"
  TOOL_DIR="$( cd "${REPO_DIR}/${TOOL_NAME}" >/dev/null 2>&1 && pwd)"
}

@test "Testing ${TOOL_NAME} tool" {
  echo "${TOOL_NAME}"
}

@test "Confirm the \$REPO_DIR variable is evaluated" {
  cd "${REPO_DIR}" && pwd
  [[ "$status" -eq 0 ]]
}

@test "Change into the tool directory for ${TOOL_NAME}" {
  cd "${TOOL_DIR}" && pwd
  [[ "$status" -eq 0 ]]
}

@test "Check for latest version of bash-snippets on update" {
  if [[ "$(uname)" == "Linux" ]]; then
    run "${TOOL_DIR}/${TOOL_NAME}" update
    [[ "$status" -eq 0 ]]
    [ "$output" == "Bash-Snippets is already the latest version" ]
  fi
}

@test "The -h option should print usage" {
  run "${TOOL_DIR}/${TOOL_NAME}" -h
  [[ "$status" -eq 0 ]]
  # if bash is less than 7 yrs old
  if ((${BASH_VERSINFO[0]} >= 4)); then
    [[ "${lines[0]}" = "${TOOL_NAME^}" ]]
  else
    # or im probably a stoneage mac
    [[ "$(echo "${output}" | grep -i "${TOOL_NAME}")" ]]
  fi
}

@test "No arguments prints usage instructions" {
  run "${TOOL_DIR}/${TOOL_NAME}"
  [[ "$status" -eq 0 ]]
  # if bash is less than 7 yrs old
  if ((${BASH_VERSINFO[0]} >= 4)); then
    [[ "${lines[0]}" = "${TOOL_NAME^}" ]]
  else
    # or im probably a stoneage mac
    [[ "$(echo "${output}" | grep -i "${TOOL_NAME}")" ]]
  fi
}

@test "Get the tools version with -v" {
  run "${TOOL_DIR}/${TOOL_NAME}" -v
  [[ "$status" -eq 0 ]]
  expected='Version'
  [[ "${output}" =~ "${expected}" ]]
}


# Tool specific tests
@test "Do that cool thing" {
  run "${TOOL_DIR}/${TOOL_NAME}" cool
  [[ "$status" -eq 0 ]]
  expected='This is awesome'
  [[ "${output}" =~ "${expected}" ]]
}

@test "Testing coolness factor" {
  run "${TOOL_DIR}/${TOOL_NAME}" cool --even-cooler
  [[ "$status" -eq 0 ]]
  expected='subzero'
  [[ "printf '%s\n' ${lines[1]}" =~ "${expected}" ]]
}

