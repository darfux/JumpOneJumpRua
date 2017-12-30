$(document).ready ->
	speed = 162 / 0.6
	state = 'none'
	p1 = {}
	$('#screenshot').click (evt) ->
		if state == 'none'
			state = 'ready'
			p1 =
				x: evt.offsetX
				y: evt.offsetY
			return
		if state == 'ready'
			state = 'waiting'
			dis = Math.sqrt((evt.offsetX - (p1.x)) ** 2 + (evt.offsetY - (p1.y)) ** 2)
			time = dis / speed
			$("#screenshot").addClass("wait")
			$.post('/jump', 'time': time).done (data) ->
				$("#screenshot").removeClass("wait")
				state = 'none'
				console.log data
				# location.href = '/?step=1'
				d = new Date();
				$("#screenshot").attr("src", "screenshot.png?"+d.getTime());
			return