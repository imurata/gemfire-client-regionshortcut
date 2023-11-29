#!/bin/bash
set -x
LOG_LEVEL=info
REGION_SHORTCUT=$1
TYPE=PARTITION_OVERFLOW
GFSH_PATH=""
which gfsh 2> /dev/null
killall java
rm -rf locator/ server/
if [ -z "$REGION_SHORTCUT" ]; then
	REGION_SHORTCUT=LOCAL
fi

if [ "$REGION_SHORTCUT" == "LOCAL" ]; then
	TYPE=LOCAL
fi
TYPE=LOCAL

gfsh -e "start locator --name=locator --classpath /opt/vmware/vmware-gemfire-10.0.1/tools/Modules/gemfire-prometheus-metrics/* --J=-Dgemfire.prometheus.metrics.port=7003" \
     -e "start server --name=server --max-heap=1G --log-level $LOG_LEVEL --classpath /opt/vmware/vmware-gemfire-10.0.1/tools/Modules/gemfire-prometheus-metrics/* --J=-Dgemfire.prometheus.metrics.port=7004" \
     -e "create region --name=exampleRegion --type=$TYPE --enable-statistics=true"

../build/gemfire-client-sample $REGION_SHORTCUT
