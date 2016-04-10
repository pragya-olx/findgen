window.Owner = ->
	console.log("Creating Owner")

window.Owner.load = ->

	$('#save_owner').click ->
	  formData = user:
	    name: $('#user_name').val()
	    location: $('#user_location').val()
	    email: $('#user_email').val()
	    phone_number: $('#user_phone_number').val()
	    role_type: 'owner'
	  $.post(
	    url: '/users'
	    data: formData).done((data) ->
	    window.location = '/owners'
	  ).fail (data) ->
	    console.log 'error'
