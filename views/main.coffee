$(document).ready ->
	speed = 162 / 0.6
	state = 'none'
	p1 = {}

	find_chess = ->
		$.getJSON('/find_chess').done (data) ->
			console.log(data)
			if data.x!=undefined
				p1 = data
				state = 'ready'
				console.log {top: "#{p1.x}px", left: "#{p1.y}px"}
				$("#chess").css({top: "#{p1.y-4}px", left: "#{p1.x-4}px"})

	find_chess()

	$('#clr-btn').click (evt)->
		console.log(evt)
		state = 'none'
		$("#chess").css({top: "0px", left: "0px"})

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
				find_chess()
			return