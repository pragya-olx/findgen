window.Booking = function() {};

Booking.load = function() {

  getUrl = function() {
    var url = window.location.href.split('?')[0];
    if (url.indexOf('#') !== -1) {
      url = url.split('#')[0]
    }
    return url;
  }

	$('#' + 'accepted').click(function(){
		window.location = getUrl() + "?booking_status=accepted"
	});
	$('#' + 'pending').click(function(){
		window.location = getUrl() + "?booking_status=pending"
	});
	$('#' + 'completed').click(function(){
		window.location = getUrl() + "?booking_status=completed"
	});
	$('#' + 'cancelled').click(function(){
		window.location = getUrl() + "?booking_status=cancelled"
	});
	$('#' + 'client_approved').click(function(){
		window.location = getUrl() + "?booking_status=client_approved"
	});

	$("#" + qs["booking_status"]).addClass('active')

	if (qs["booking_status"] == undefined) {
		$("#accepted").addClass('active')
	}

	$("#save_bookings").click(function(){
    $("#bookingForm").find('input[type=submit]').click()
  });

  $("#bookingForm").on('submit', function(event){
    event.preventDefault();

    if(!$("#bookingForm")[0].checkValidity() || $("#startDate input").val() == "" ||
        $("#timeIn input").val() == "" || $("#timeOut input").val() == "" || $('#lisp').val() =="" ||
        $('#assessment').val() == ""
      ) {
      $("#form_error").show()
      return
    }

    currentDate = new Date()
    bookingDate = new Date($("#startDate").find('input').val())

    dateCheck = true
    if ( bookingDate < currentDate ) {
      dateCheck = confirm("You created a past booking. Is that ok?")
    }
    checkforsamecenterandDate();
    if(dateCheck){
      $("#save_bookings").hide()
      $("#save_bookings_loading").show()

  	 	formData = {
  	 		booking: {
      	 		start_date: $("#startDate input").val(),
      	 		time_in: $("#timeIn input").val(),
      	 		time_out: $("#timeOut input").val(),
      	 		gen_type: $('#gen_type').val(),
      	 		lisp: $('#lisp').val(),
      	 		kva: $('#kva').val(),
      	 		client_id: clientId,
      	 		employee_id: $('#employee_id').val(),
            assessment: $('#assessment').val(),
            spoc_remarks: $('#spoc_remarks').val(),
            rep_phone_number: $("#rep_phone_number").val()
      	}
  	 	}

    	 	$.post({
        		url: '/bookings',
        		data: formData
        	}).done(function(data){
            $(".close").click()
            $("#success_message").text('Booking created successfully, Refreshing the page!').show()
            setTimeout("location.reload()",1000)
        	}).fail(function(data){
        		$("#form_error").val(data.error().responseText).show()
            $("#save_bookings").prop('disabled',false)
        	});
      }
	 });
};

 function checkforsamecenterandDate()
    {

      formData = {
          booking: {    
           lispcenter : $('#lisp').val(),
           date : $("#startDate input").val()
        }
       }
         $.post({
            url: '/bookings/find_by_date_and_center',
            data: formData
          }).done(function(data){
            setTimeout("location.reload()",1000)
          }).fail(function(data){
            $("#form_error").val(data.error().responseText).show()
            $("#save_bookings").prop('disabled',false)
          });
    }