function closePlayer() {
	vlc.playlist.stop();
	$("player_canvas").style.display = 'none';
}

function showPlayer() {
	$("player_canvas").style.display = 'block';
}

function play(nvr,pathFile) {
	vlc.playlist.clear();
	var id = vlc.playlist.add("rtsp://" + nvr.split(':')[0] + pathFile);
	if(confirm("确定开始回放录像?")) {
		vlc.playlist.playItem(id);
		showPlayer();
	}
}

function remove_record_files(spot_id) {
	if(confirm("确定要删除该监控点的所有录像文件吗？")) {
		new Ajax.Request("/records/remove/" + spot_id, {asynchronous:false, evalScripts:true});
	}
}