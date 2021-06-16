#!/bin/bash

.scripts/k8s-up.sh
.scripts/k8s-smoke.sh
code=$?
.scripts/k8s-down.sh
exit $code
