$(document).ready ->
	if !window.clientId?
		window.clientId = null
	Client.load()
	User.load()
	Booking.load()