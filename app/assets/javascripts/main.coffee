$(document).ready ->
	if !window.clientId?
		window.clientId = null
	Client.load()
	Booking.load()
	Owner.load()