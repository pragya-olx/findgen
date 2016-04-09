$(function() {
    $(document).ready(function() {
    	var t = $("#example").DataTable();

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

    	showPending = function() {
    		$.ajax({
	    		url: '/bookings',
	    		data: {status: "pending"},
	    		datatype : "json"
	    	}).done(function(data){
	    		refreshBookings(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#pending').addClass('active');
	    	$("#active").removeClass('active');
	    	$("#previous").removeClass('active');
    	}

    	showActive = function() {
    		$.ajax({
	    		url: '/bookings',
	    		data: {status: "approved"},
	    		datatype : "json"
	    	}).done(function(data){
	    		refreshBookings(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#active').addClass('active');
	    	$("#pending").removeClass('active');
	    	$("#previous").removeClass('active');
    	}

    	showPrevious = function() {
    		$.ajax({
	    		url: '/bookings',
	    		datatype : "json"
	    	}).done(function(data){
	    		refreshBookings(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#active').removeClass('active');
	    	$("#pending").removeClass('active');
	    	$("#previous").addClass('active');
    	}

		$('#active').click(showActive)
		$('#pending').click(showPending)
		$('#previous').click(showPrevious)



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
	    		$('#createModal').modal('hide')
	    		showPending();
	    	}).fail(function(data){
	    		console.log("error")
	    	});

    	 });

    } );


});
