By CyrusFox for OpenWifiMap
Not much of a readme file ;) only a few remarks.

oldnodes.js - View for couchdb which emits only nodes where the lastupdate is more than 24h ago

deletenodes_old - Uses the couchdb view above to get "old" nodes and deletes them

Deletenodes_manual - Manually delete a node or nodes from the couchdb if you know the document ID ;) 
