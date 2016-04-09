window.Booking = function() {};

Booking.load = function() {
	var t = $("#bookings").DataTable();

	refreshBookings = function(data) {
		t.clear().draw();
		for(var i = 0; i < data.length; i++) {
			t.row.add([
				data[i].name,
				data[i].location,
				data[i].start_date,
				data[i].end_date,
				data[i].gen_type,
				data[i].status,
				null,
				null
			]).draw();
		}
	};

	showBookings = function(bookingStatus) {
		
		$.ajax({
    		url: '/bookings',
    		data: {status: bookingStatus},
    		datatype : "json"
    	}).done(function(data){
    		refreshBookings(data);
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

	$('#active').click(function(){
		showBookings('approved')
	});
	$('#pending').click(function(){
		showBookings('pending')
	});
	$('#previous').click(function(){
		showBookings('previous')
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
    		showBookings('pending')
    	}).fail(function(data){
    		console.log("error")
    	});

	 });
};

