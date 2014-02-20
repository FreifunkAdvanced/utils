#!/bin/bash
map_server=map.freifunk-rheinland.net
confirm=$1

fail() {
    echo "$1" 1>&2
    exit 1
}

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

[ "$confirm" == "YES" ] || fail 'Warning! This deletes all nodes from the map, append YES to the command to delete the nodes'

ids=$(curl "http://$map_server/openwifimap/_design/allnodes/_view/allnodes.js" -H "Connection: close" -4 | grep id | cut -f4 -d'"' | sed 's/\r/ /')

[ -n "$ids" ] || fail 'Got no IDs from server. Either the server did not respond or there are no nodes to delete. Nothing to do here!'

for id in $(echo $ids)
do
	delete_doc $id
done

