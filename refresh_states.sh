#!/bin/sh
while true; do
	curl http://localhost/gateway/spot_states
	sleep 3
done
