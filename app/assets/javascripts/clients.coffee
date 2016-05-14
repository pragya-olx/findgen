window.Client = ->
  console.log("Creating client")

window.Client.load = ->
    t = $('#clients').DataTable();
    $("#lisp").select2({
      placeholder: "Select a LISP",
      allowClear: true
    })
    $("#employee_id").select2()
    $("#secondary_lisp").select2()

    refreshClients = (data) ->
      t.clear().draw()
      i = 0
      while i < data.length
        if !data[i].balance?
          data[i].balance = 0
        t.row.add([
          data[i].id,
          data[i].name,
          data[i].email,
          data[i].balance
        ]).draw()
        i++

    $.ajax(
      url: '/clients.json'
    ).done((data) ->
      refreshClients(data)
    )

    $('#clients tbody').on('click', 'tr', ->
      id = $(this).find('td').first().text()
      window.location = "/clients/#{id}"
    )

    $("#" + qs["booking_status"]).parent().addClass('active')

    if !qs["booking_status"]?
      $("#accepted").parent().addClass('active')

    $('#navTabs a').click((e) ->
      e.preventDefault()
      $(this).tab('show')
      if $(this).text() == "Users"
        location.hash = "users"
        $(".users_content").show()
        $(".bookings_content").hide()
        $("#lisps_content").hide()
        $("#groups_content").hide()
        $("#subgroups_content").hide()
        $("#assessments_content").hide()
      else if $(this).text() == "Bookings"
        location.hash = ""
        $(".users_content").hide()
        $(".bookings_content").show()
        $("#lisps_content").hide()
        $("#groups_content").hide()
        $("#subgroups_content").hide()
        $("#assessments_content").hide()
      else if $(this).text() == "LISP"
        location.hash = "lisps"
        $(".users_content").hide()
        $(".bookings_content").hide()
        $("#lisps_content").show()
        $("#groups_content").hide()
        $("#subgroups_content").hide()
        $("#assessments_content").hide()
      else if $(this).text() == "Groups"
        location.hash = "groups"
        $(".users_content").hide()
        $(".bookings_content").hide()
        $("#lisps_content").hide()
        $("#groups_content").show()
        $("#subgroups_content").hide()
        $("#assessments_content").hide()
      else if $(this).text() == "Subgroups"
        location.hash = "subgroups"
        $(".users_content").hide()
        $(".bookings_content").hide()
        $("#lisps_content").hide()
        $("#groups_content").hide()
        $("#subgroups_content").show()
        $("#assessments_content").hide()
      else if $(this).text() == "Assessment Codes"
        location.hash = "assessments"
        $(".users_content").hide()
        $(".bookings_content").hide()
        $("#lisps_content").hide()
        $("#groups_content").hide()
        $("#subgroups_content").hide()
        $("#assessments_content").show()
      else
        location.hash = ""
    )

    $('#createClient').find('#save').click ->
      formData = client:
        name: $('#name').val()
        location: $('#location').val()
        email: $('#email').val()
      $.post(
        url: '/clients'
        data: formData)
      .done((data) ->
        $('#createClient').modal 'hide'
        refreshClients(data)
      ).fail (data) ->
        console.log 'error'

