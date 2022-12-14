#!/bin/bash
 
#Start ACL build process
curl -s -u api_16ed2a40d66fb4003:1ab9f0644d0e14d02b972ec8f6f356ef2b4d2589f09d1b7575b76d5350fd4525 -H "Content-Type: application/json"  -d {} -X POST https://jds-demo-snc.poc.segmentationpov.com:8443/api/v2/orgs/1/network_devices/6139c31b-95cc-4cb3-8ff6-2363f44aba95/enforcement_instructions_request > /dev/null 2>&1
echo "Getting Switch ACL"
#look for acl build to finish.

loop=true
while $loop   
do
	results=$(curl -s -u api_16ed2a40d66fb4003:1ab9f0644d0e14d02b972ec8f6f356ef2b4d2589f09d1b7575b76d5350fd4525 -H "Content-Type: application/json"  -X GET https://jds-demo-snc.poc.segmentationpov.com:8443/api/v2/orgs/1/network_devices/6139c31b-95cc-4cb3-8ff6-2363f44aba95 | jq .enforcement_instructions_generation_in_progress)
	sleep 3
	if [[ $results == "null" ]]; then
		loop=false
	else 
		echo "waiting"
	fi
done

datafile=$(curl -s -u api_16ed2a40d66fb4003:1ab9f0644d0e14d02b972ec8f6f356ef2b4d2589f09d1b7575b76d5350fd4525 -H "Content-Type: application/json"  -X GET https://jds-demo-snc.poc.segmentationpov.com:8443/api/v2/orgs/1/network_devices/6139c31b-95cc-4cb3-8ff6-2363f44aba95 | jq .enforcement_instructions_data_href | tr -d '"')

echo 'getting ACL '$datafile
curl -u api_16ed2a40d66fb4003:1ab9f0644d0e14d02b972ec8f6f356ef2b4d2589f09d1b7575b76d5350fd4525   -X GET https://jds-demo-snc.poc.segmentationpov.com:8443/api/v2/$datafile



curl -u api_16ed2a40d66fb4003:1ab9f0644d0e14d02b972ec8f6f356ef2b4d2589f09d1b7575b76d5350fd4525 -H "Content-Type: application/json"  -d {} -X POST https://jds-demo-snc.poc.segmentationpov.com:8443/api/v2/orgs/1/network_devices/6139c31b-95cc-4cb3-8ff6-2363f44aba95/enforcement_instructions_applied > /dev/null 2>&1
