#!/bin/bash
map_server=map.freifunk-rheinland.net

fail() {
	echo "$1" 1>&2
	exit 1
}

printArgs () {
	fail "Usage:
$0 ID or "Multiple IDs space seperated"
"
}

[ $# -lt 1 ] && printArgs

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
[ -n "$1" ] && ids="$1"

for id in $(echo $ids)
do
	delete_doc $id
done

