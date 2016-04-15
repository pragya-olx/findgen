window.Booking = function() {};

Booking.load = function() {
	// var pendingTable = $("#pending_bookings").DataTable();
	// var allBookings = $("#bookings").DataTable();
	// var statuses = ['pending', 'approved', 'previous']

	// refreshBookings = function(data,t) {
	// 	t.clear().draw();
	// 	for(var i = 0; i < data.length; i++) {
	// 		t.row.add([
	// 			data[i].id,
	// 			data[i].name,
	// 			data[i].location,
	// 			data[i].start_date,
	// 			data[i].end_date,
	// 			data[i].gen_type,
	// 			data[i].status,
	// 			data[i].client_id,
	// 			data[i].user_id,
	// 		]).draw();
	// 	}
	// };

	// showBookings = function(bookingStatus, t) {
		
	// 	$.ajax({
 //    		url: '/bookings',
 //    		data: {status: bookingStatus, client_id: clientId ? clientId : ""},
 //    		datatype : "json"
 //    	}).done(function(data){
 //    		refreshBookings(data, t);
 //    	}).fail(function(data){
 //    		console.log("error")
 //    	});

 //    	var i = 0;
 //    	while(i < statuses.length) {
 //    		status = statuses[i];
 //    		i++;
 //    		if(status == bookingStatus) {
 //    			$("#" + status).addClass('active')
 //    		} else {
 //    			$("#" + status).removeClass('active')
 //    		}
 //    	}
	// }

	// showBookings('pending', pendingTable)

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
	$('#' + 'previous').click(function(){
		window.location = url + "?booking_status=previous"
	});

	if (qs["booking_status"] == "pending") {
		$("#pending").addClass('active')
		$("#previous").removeClass('active')
		$("#approved").removeClass('active')
	} else if (qs["booking_status"] == "previous") {
		$("#pending").removeClass('active')
		$("#approved").removeClass('active')
		$("#previous").addClass('active')
	} else {
		$("#pending").removeClass('active')
		$("#approved").addClass('active')
		$("#previous").removeClass('active')
	}

	  $('#datetimepicker1').datetimepicker();
	  $('#datetimepicker2').datetimepicker();

	 $("#save_bookings").click(function(){

	 	formData = {
	 		booking: {
    	 		name: $('#booking_name').val(),
    	 		location: $('#booking_location').val(),
    	 		start_date: $("#datetimepicker1 input").val(),
    	 		end_date: $("#datetimepicker2 input").val(),
    	 		gen_type: $('#type').val(),
    	 		client_id: clientId
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

