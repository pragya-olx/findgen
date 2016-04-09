window.Booking = function() {};

Booking.load = function() {
	var pendingTable = $(".pending table").DataTable();
	var allBookings = $("#bookings").DataTable();

	refreshBookings = function(data,t) {
		t.clear().draw();
		for(var i = 0; i < data.length; i++) {
			t.row.add([
				data[i].name,
				data[i].location,
				data[i].start_date,
				data[i].end_date,
				data[i].gen_type,
				data[i].status,
				data[i].client_id,
				null,
				null
			]).draw();
		}
	};

	showBookings = function(bookingStatus, t) {
		
		$.ajax({
    		url: '/bookings',
    		data: {status: bookingStatus, client_id: window.clientId},
    		datatype : "json"
    	}).done(function(data){
    		refreshBookings(data, t);
    	}).fail(function(data){
    		console.log("error")
    	});

    	statuses = ['pending', 'approved', 'previous']
    	for (var status in statuses) {
    		if(status == bookingStatus) {
    			$("#" + status).addClass('active')
    		} else {
    			$("#" + status).removeClass('active')
    		}
    	}
	}

	showBookings('pending', pendingTable)

	$('#active').click(function(){
		showBookings('approved', allBookings)
	});
	$('#pending').click(function(){
		showBookings('pending', allBookings)
	});
	$('#previous').click(function(){
		showBookings('previous', allBookings)
	});


	 $('#datetimepicker1').datetimepicker();
	 $('#datetimepicker2').datetimepicker();

	 $("#save_bookings").click(function(){

	 	formData = {
	 		booking: {
    	 		name: $('#name').val(),
    	 		location: $('#location').val(),
    	 		start_date: $("#datetimepicker1 input").val(),
    	 		end_date: $("#datetimepicker2 input").val(),
    	 		gen_type: $('#type').val(),
    	 	}
	 	};

	 	$.post({
    		url: '/bookings',
    		data: formData
    	}).done(function(data){
    		$('#createBooking').modal('hide')
    		showBookings('pending', allBookings)
    	}).fail(function(data){
    		console.log("error")
    	});

	 });
};

