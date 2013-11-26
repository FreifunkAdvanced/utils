#!/bin/bash
map_server=map.freifunk-rheinland.net

get_rev() {
	local docid=$1
	curl http://$map_server/openwifimap/$docid -vvvv -X HEAD -4 -H "Connection: close" 1&> /tmp/owm_revision
	local etag=$(cat /tmp/owm_revision | grep ETag | cut -d '"' -f2)
	echo $etag
}

delete_doc() {
	local docid=$1
	local rev=$(get_rev $docid)
	if [ -n "$docid" -a -n "$rev" ]; then
		echo "Deleting ID: $docid Rev: $rev"
		curl "http://$map_server/openwifimap/$docid?rev=$rev" -X DELETE -4 -H "Connection: close" 1&> /dev/null
	fi
}

ids=$(curl "http://$map_server/openwifimap/_design/oldnodes/_view/oldnodes.js" -H "Connection: close" -4 | grep id | cut -f4 -d'"' | sed 's/\r/ /')

for id in $(echo $ids)
do
	delete_doc $id
done

