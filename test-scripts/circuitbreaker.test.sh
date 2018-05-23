#!/bin/bash
invalidReqUrl='http://localhost:8889/calculator/bmi?height=178&weight=-81'
validReqUrl='http://localhost:8889/calculator/bmi?height=178&weight=81'

function badReq() {
	local status=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $invalidReqUrl)
	echo $status
}

function goodReq() {
	#function_body
	local status=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $validReqUrl)
	echo $status
}

echo "The first 5 requests are made to trigger circuit breaker with a negative weight"
echo "The last 5 requests should receive error, even with valid parameter"

echo "Request with url: $invalidReqUrl"
for i in {1..5}
do
	status=$(badReq)
	echo $i $status
	echo
done

echo '> circuit breaker should be triggered'
echo

echo "Request with url: $validReqUrl"
for i in {1..5}
do
	status=$(goodReq)
	echo $i $status
	echo
done
