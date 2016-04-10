window.User = ->
	console.log("Creating User")

window.User.load = ->
	t = $('#users').DataTable()

	refreshUsers = (data) ->
	  t.clear().draw()
	  i = 0
	  while i < data.length
	    t.row.add([
	      data[i].name
	      data[i].location
	      data[i].email
	      data[i].phone_number
	      data[i].role_type
	    ]).draw()
	    i++

	showUsers = (user) ->
	  $.ajax(
	    url: '/users'
	    data: {role_type: user, client_id: clientId}
	    datatype: 'json').done((data) ->
	    refreshUsers data
	    return
	  ).fail (data) ->
	    console.log 'error'
	  types = [
	    'admin',
	    'spoc',
	    'vendor',
	    'owner'
	  ]
	  for type in types
	    if type == user
	      $('#' + type).addClass 'active'
	    else
	      $('#' + type).removeClass 'active'

	showUsers('admin')

	$('#admin').click ->
	  showUsers 'admin'
	$('#spoc').click ->
	  showUsers 'spoc'
	$('#vendor').click ->
	  showUsers 'vendor'
	$('#owner').click ->
	  showUsers 'owner'
	$('#save').click ->
	  formData = user:
	    name: $('#name').val()
	    location: $('#location').val()
	    email: $('#email').val()
	    phone_number: $('#phone_number').val()
	    role_type: $('#role_type').val()
	  $.post(
	    url: '/users'
	    data: formData).done((data) ->
	    $('#createUser').modal 'hide'
	    showUsers 'admin'
	    return
	  ).fail (data) ->
	    console.log 'error'
