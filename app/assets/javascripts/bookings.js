window.Booking = function() {};

Booking.load = function() {

	$('#dashboard_bookings tbody').on('click', 'tr', function(){
      id = $(this).find('td').first().text();
      window.location = "/bookings/" + id;
    });

 	var url = window.location.href.split('?')[0];
	$('#' + 'approved').click(function(){
		window.location = url + "?booking_status=approved"
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
	$('#' + 'approver_approved').click(function(){
		window.location = url + "?booking_status=approver_approved"
	});

	$("#" + qs["booking_status"]).addClass('active')

	 $("#save_bookings").click(function(){

	 	formData = {
	 		booking: {
    	 		start_date: $("#startDate input").val(),
    	 		end_date: $("#endDate input").val(),
    	 		time_in: $("#timeIn input").val(),
    	 		time_out: $("#timeOut input").val(),
    	 		gen_type: $('#gen_type').val(),
    	 		lisp: $('#lisp').val(),
    	 		kva: $('#kva').val(),
    	 		client_id: clientId,
    	 		rep_id: $('#rep_id').val()
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

