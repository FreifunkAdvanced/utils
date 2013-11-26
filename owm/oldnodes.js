function(doc) {
	var time = new Date();
	var updatetime = new Date(doc.lastupdate)
	var timediff = time.getTime() - updatetime.getTime()
    
	if (doc.type=='node' && doc.longitude && doc.latitude && timediff > 8640000){
		emit(null, doc.lastupdate);
	}
}
