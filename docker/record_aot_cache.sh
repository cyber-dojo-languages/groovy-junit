#!/bin/bash
# Invoked as [bash record_aot_cache.sh], and that ignores the shebang line, so
# the shell options have to be set here to have any effect. Set on the shebang
# alone they are silently absent, and a workload that failed to compile leaves
# an image the build then reports as a success.
set -Eeu -o pipefail

# Records the AOT cache groovyc replays on every [test] press.
#
# A kata runs in a container thrown away afterwards, so every press pays a full
# JVM startup for the compiler. That is not a component of the wait, it is most
# of it. An AOT cache holds the classes that JVM loads, in the form the JVM
# wants them, and reading one back costs a fraction of loading them again.
#
# The JVM that runs the tests gets no cache of its own. cyber-dojo.sh puts the
# directory holding the classes groovyc has just written on that JVM's own
# classpath, and a cache cannot be written from a classpath naming a non-empty
# directory.
#
# A learner's own classes never enter the cache, which is what makes it keep
# working as the learner edits. What it holds is the compiler's classes, and
# recording it from the throwaway kata below is what keeps any kata's out.

readonly WORK_DIR=/tmp/record_aot_cache
readonly CACHE_DIR=/aot
readonly GROOVYC_CACHE="${CACHE_DIR}/groovyc.aot"

mkdir -p "${WORK_DIR}" "${CACHE_DIR}"
cp /tmp/throwaway_kata/*.groovy "${WORK_DIR}"
cd "${WORK_DIR}"

# Recorded from the same command line cyber-dojo.sh runs, so that the classes
# held are the ones a kata actually loads.
JAVA_OPTS="-XX:AOTCacheOutput=${GROOVYC_CACHE}" \
  groovyc ./*.groovy

# The sandbox user reads it at run time and owns nothing here.
chmod 0644 "${GROOVYC_CACHE}"

cd /
rm -rf "${WORK_DIR}"

ls --format=long "${GROOVYC_CACHE}"
