$(function() {
    $(document).ready(function() {
    	$("#example").DataTable();

    	$.ajax({
    		url: '/bookings'
    	}).done(function(data){
    		console.log(data);
    	}).fail(function(data){
    		console.log("error")
    	});

    	 $('#datetimepicker1').datetimepicker();

    	 $("#save").click(function(){
    	 	$.post({
	    		url: '/bookings'
	    		data: {}
	    	}).done(function(data){
	    		console.log(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});

    	 })

        // var newRow;
        // $("#example tbody").append(newRow);
    } );

});
