#!/bin/bash -Eeu

# Appends one test framework to the test_frameworks list the base image
# wrote in /versions.json, keeping any entry an earlier image added. Stops
# the build if the list is not found, rather than record nothing.
add_test_framework()
{
  local -r name="${1}"
  local -r version="${2}"
  local -r entry="{\"name\": \"${name}\", \"version\": \"${version}\"}"
  if grep -q '"test_frameworks": \[\]' /versions.json; then
    sed -i "s|\"test_frameworks\": \[\]|\"test_frameworks\": [${entry}]|" /versions.json
  else
    sed -i "/\"test_frameworks\": \[/s|}\]|}, ${entry}]|" /versions.json
  fi
  if ! grep -q -F "${entry}" /versions.json; then
    echo "Could not add ${name} to /versions.json" >&2
    cat /versions.json >&2
    exit 1
  fi
}

# The jars are taken from the distribution by glob rather than by name. The
# base resolves the newest stable groovy when it is built, and that groovy
# carries the JUnit it ships with, so a name here would be a second copy of a
# version this image does not choose.
mkdir /groovy
cp "${GROOVY_HOME}"/lib/groovy-[0-9]*.jar   /groovy/
cp "${GROOVY_HOME}"/lib/hamcrest-core-*.jar /groovy/
cp "${GROOVY_HOME}"/lib/junit-4*.jar        /groovy/

readonly JUNIT_JAR="$(basename /groovy/junit-4*.jar)"
add_test_framework JUnit "$(echo "${JUNIT_JAR}" | sed 's/^junit-\(.*\)\.jar$/\1/')"
cat /versions.json
