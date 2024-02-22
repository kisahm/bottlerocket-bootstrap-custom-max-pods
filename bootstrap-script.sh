#!/usr/bin/env bash

# Source environment variables defined in bootstrap container's user-data
USER_DATA_DIR=/.bottlerocket/bootstrap-containers/current
source "$USER_DATA_DIR/user-data"

if [ "${CUSTOM_NETWORKING}" = "true" ]; then
  CUSTOM_NETWORKING_ARG="--cni-custom-networking-enabled"
fi
if [ "${PREFIX_DELEGATION}" = "true" ]; then
  PREFIX_DELEGATION_ARG="--cni-prefix-delegation-enabled"
fi

# Runs the max-pods-calculator script to calculate max pods
max_pods=$(max-pods-calculator.sh \
  --instance-type-from-imds \
  ${CUSTOM_NETWORKING_ARG} \
  ${PREFIX_DELEGATION_ARG} \
  ${ADDITIONAL_OPTIONS})
if [ ${?} -ne 0 ]; then
  echo "ERROR: Failed to calculate max-pods value using the max-pods-calculator helper script: ${max_pods}" >&2
  exit 1
fi

# Set the max-pods setting via Bottlerocket's API
apiclient set kubernetes.max-pods=${max_pods}

if [ ${?} -ne 0 ]; then
  echo "ERROR: Failed set kubernetes.max-pods setting via Bottlerocket API" >&2
  exit 1
fi