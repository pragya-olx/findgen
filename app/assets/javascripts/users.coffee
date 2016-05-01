window.User = ->
	console.log("Creating User")

window.User.load = ->
	t = $('#users').DataTable()

	refreshUsers = (data) ->
	  t.clear().draw()
	  i = 0
	  while i < data.length
	    t.row.add([
	      data[i].id
	      data[i].name
	      data[i].location
	      data[i].email
	      data[i].phone_number
	      data[i].role_type
	      data[i].employee_id
	    ]).draw()
	    i++

	showUsers = (user) ->
	  $.ajax(
	    url: '/users'
	    data: {role_type: user, client_id: clientId}
	    datatype: 'json').done((data) ->
	    refreshUsers data
	  ).fail (data) ->
	    console.log 'error'
	  types = [
	    'admin',
	    'spoc',
	    'approver',
	    'employee'
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
	$('#employee').click ->
	  showUsers 'employee'
	$('#approver').click ->
	  showUsers 'approver'


	$('#save_user').click -> 
		if $('#user_name').val() == ''
	      alert 'Please Enter Employee Name'
	    else if $('#user_location').val() == ''
	      alert 'Please Enter Location'
	    else if $('#user_phone_number').val() == ''
	      alert 'Please Enter Phone Number'
	    else if $('#user_email').val() == ''
	      alert 'Please Enter EMail'
	    else if $('#user_employee_id').val() == ''
	      alert 'Please Enter Employee ID'
	    else 
		  formData = user:
		    name: $('#user_name').val()
		    location: $('#user_location').val()
		    email: $('#user_email').val()
		    phone_number: $('#user_phone_number').val()
		    role_type: $('#role_type').val()
		    client_id: clientId
		    employee_id: $('#user_employee_id').val()
		  $.post(
		    url: '/users'
		    data: formData).done((data) ->
		    $('#createUser').modal 'hide'
		    showUsers 'admin'
		    return
		  ).fail (data) ->
		    alert data.error().responseText
