$(function() {
    $(document).ready(function() {
    	var t = $("#users").DataTable();

    	refreshTable = function(data) {
    		t.clear().draw();
    		for(var i = 0; i < data.length; i++) {
    			t.row.add([
    				data[i].name,
    				data[i].location,
    				data[i].email,
    				data[i].phone_number,
    				data[i].role_type,
    			]).draw();
    		}
    	};

    	showAdmin = function() {
    		$.ajax({
	    		url: '/users',
	    		data: {role_type: "admin"},
	    		datatype : "json"
	    	}).done(function(data){
	    		refreshTable(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#admin').addClass('active');
	    	$("#spoc").removeClass('active');
	    	$("#vendor").removeClass('active');
	    	$("#owner").removeClass('active');
    	}

    	showSPOC = function() {
    		$.ajax({
	    		url: '/users',
	    		data: {role_type: "spoc"},
	    		datatype : "json"
	    	}).done(function(data){
	    		refreshTable(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#admin').removeClass('active');
	    	$("#spoc").addClass('active');
	    	$("#vendor").removeClass('active');
	    	$("#owner").removeClass('active');
    	}

    	showVendors = function() {
    		$.ajax({
	    		url: '/users',
	    		data: {role_type: "vendor"},
	    	}).done(function(data){
	    		refreshTable(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#admin').removeClass('active');
	    	$("#spoc").removeClass('active');
	    	$("#vendor").addClass('active');
	    	$("#owner").removeClass('active');
    	}

    	showOwners = function() {
    		$.ajax({
	    		url: '/users',
	    		data: {role_type: "owner"},
	    	}).done(function(data){
	    		refreshTable(data);
	    	}).fail(function(data){
	    		console.log("error")
	    	});
	    	$('#admin').removeClass('active');
	    	$("#spoc").removeClass('active');
	    	$("#vendor").removeClass('active');
	    	$("#owner").addClass('active');
	    };

		$('#admin').click(showAdmin)
		$('#spoc').click(showSPOC)
		$('#vendor').click(showVendors)
		$('#owner').click(showOwners)


    	 $("#save").click(function(){

    	 	formData = {
    	 		user: {
	    	 		name: $('#name').val(),
	    	 		location: $('#location').val(),
	    	 		email: $("#email").val(),
	    	 		phone_number: $("#phone_number").val(),
	    	 		role_type: $('#role_type').val(),
	    	 	}
    	 	};

    	 	$.post({
	    		url: '/users',
	    		data: formData
	    	}).done(function(data){
	    		$('#createModal').modal('hide')
	    		showPending();
	    	}).fail(function(data){
	    		console.log("error")
	    	});

    	});
    });
});
