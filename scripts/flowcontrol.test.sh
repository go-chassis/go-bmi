#!/bin/bash
echo "The requests should be delayed after flow control is triggered, around request no.10"
echo

for i in {1..25}
do
	start=$(date +%s%N)
	status=$(curl -I -m 10 -o /dev/null -s -w %{http_code} 'http://localhost:8889/calculator/bmi?height=178&weight=81')
	finish=$(date +%s%N)
	duration=$(( ($finish - $start) / 1000000 ))
	echo $i status: $status, in: $duration "ms"
	sleep 0.1
done
