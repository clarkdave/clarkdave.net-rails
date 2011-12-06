# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

drag_drop_setup = (picker, container_w, container_h) ->

	dragging = false
	prev_x = null
	prev_y = null
	cur_x = parseInt $(picker).css('left')
	cur_y = parseInt $(picker).css('top')

	box_width = parseInt $(picker).width()
	box_height = parseInt $(picker).height()
	max_x = container_w
	max_y = container_h

	pickup_selector = ->
		dragging = true
		$(picker).css('z-index', 1000)

	drop_selector = ->
			dragging = false
			prev_x = null
			prev_y = null
			cur_x = parseInt $(picker).css('left')
			cur_y = parseInt $(picker).css('top')
			$(picker).css('z-index', 0)
			$(picker).removeClass 'active'

	picker.click ->
		if dragging
			drop_selector()
			$(@).removeClass 'active'
		else
			pickup_selector()
			$(@).addClass 'active'

	picker.mouseout ->
		drop_selector() if dragging

	

	picker.mousemove (e) ->
		if dragging
			if prev_x == null
				prev_x = e.clientX
				prev_y = e.clientY
			else
				move_x = e.clientX - prev_x
				move_y = e.clientY - prev_y

				if cur_x + box_width + move_x <= max_x and cur_x + move_x >= 0
					cur_x = cur_x + move_x
					$(@).css 'left', cur_x + 'px'

				if cur_y + box_height + move_y <= max_y and cur_y + move_y >= 0
					cur_y = cur_y + move_y
					$(@).css 'top', cur_y + 'px'

				prev_x = e.clientX
				prev_y = e.clientY

post_create_thumb = (id) ->

	type = ''
	thumb_element = null

	switch id
		when 'create-mini'
			type = 'mini'
			thumb_element = $('.mini-thumb-selector')
		when 'create-banner'
			type = 'banner'
			thumb_element = $('.banner-thumb-selector')

	width = thumb_element.width()
	height = thumb_element.width()
	pos_x = parseInt thumb_element.css('left')
	pos_y = parseInt thumb_element.css('top')
	scale = $('#thumb-creator-box .source').css('background-size').split(' ')[0]
	if scale is 'auto'
		scale = 100
	else
		scale = parseInt scale

	$.ajax({
		type: 'POST',
		url: '/work/1/create_thumb',
		data: "type=#{type}&scale=#{scale}&width=#{width}&height=#{height}&pos_x=#{pos_x}&pos_y=#{pos_y}",
		error: ->
			alert('There was an error creating the thumb...')
	})

	

$(document).ready ->

	$('#thumb-create').click ->
		size = $(this).attr('title').split('x')
		container = size.slice(0)
		container[0] = parseInt(size[0]) + 50
		container[1] = parseInt(size[1]) + 40
		
		creator_box = $("<div id='thumb-creator-box'></div>")
			.css('width', container[0] + 'px')
			.css('margin-left', -((container[0])/2) + 'px')

		src_url = $('#thumb-create-src').attr('src')

		source_div = $("<div class='source'></div>")
			.css('width', size[0] + 'px')
			.css('height', size[1] + 'px')
			.css('background-image', 'url(' + src_url + ')')
			.appendTo(creator_box)

		dragging = false
		mouseovered = false

		banner_thumb_selector = $("<div class='banner-thumb-selector'></div>")
			.appendTo(source_div)

		mini_thumb_selector = $("<div class='mini-thumb-selector'></div>")
			.appendTo(source_div)

		drag_drop_setup(mini_thumb_selector, size[0], size[1])
		drag_drop_setup(banner_thumb_selector, size[0], size[1])

		$("<div class='buttons'><input id='scaler' type='number' min='5' max='100' value='100' /><p><button id='create-mini'>Create mini thumb</button> <button id='create-banner'>Create banner thumb</button></p></div>")
			.prependTo(creator_box)

		$('button', creator_box).click ->
			post_create_thumb $(this).attr('id')

		$('input#scaler', creator_box).keyup ->
			nsize = $(@).val()
			return if nsize < 10 or nsize > 100

			# scale the source image
			source_div.css('background-size', nsize + '%')

			# hide banner selector if it no longer fit
			selector_width = banner_thumb_selector.width() + 2 + parseInt(banner_thumb_selector.css('left'))
			selector_height = banner_thumb_selector.height() + 2 + parseInt(banner_thumb_selector.css('top'))

			background_w = size[0] * (nsize / 100)
			background_h = size[1] * (nsize / 100)

			console.log selector_width
			console.log background_w

			if selector_width > background_w or selector_height > background_h
				console.log 1
				banner_thumb_selector.fadeOut(100) if banner_thumb_selector.is(':visible')
			else
				console.log 2
				banner_thumb_selector.fadeIn(100) unless banner_thumb_selector.is(':visible')


		creator_box
			.hide().prependTo($('body')).fadeIn(100)