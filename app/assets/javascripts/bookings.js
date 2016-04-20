window.Booking = function() {};

Booking.load = function() {

 	var url = window.location.href.split('?')[0];
	$('#' + 'accepted').click(function(){
		window.location = url + "?booking_status=accepted"
	});
	$('#' + 'pending').click(function(){
		window.location = url + "?booking_status=pending"
	});
	$('#' + 'completed').click(function(){
		window.location = url + "?booking_status=completed"
	});
	$('#' + 'cancelled').click(function(){
		window.location = url + "?booking_status=cancelled"
	});
	$('#' + 'client_approved').click(function(){
		window.location = url + "?booking_status=client_approved"
	});

	$("#" + qs["booking_status"]).addClass('active')

	 $("#save_bookings").click(function(){

	 	formData = {
	 		booking: {
    	 		start_date: $("#startDate input").val(),
    	 		time_in: $("#timeIn input").val(),
    	 		time_out: $("#timeOut input").val(),
    	 		gen_type: $('#gen_type').val(),
    	 		lisp: $('#lisp').val(),
    	 		kva: $('#kva').val(),
    	 		client_id: clientId,
    	 		employee_id: $('#employee_id').val()
    	 	}
	 	};

	 	$.post({
    		url: '/bookings',
    		data: formData
    	}).done(function(data){
    		location.reload()
    		
    	}).fail(function(data){
    		console.log("error")
    	});

	 });
};

