window.Client = ->
  console.log("Creating client")

window.Client.load = ->
    t = $('#clients').DataTable();

    refreshClients = (data) ->
      t.clear().draw()
      i = 0
      while i < data.length
        if !data[i].balance?
          data[i].balance = 0
        t.row.add([
          data[i].id,
          data[i].name,
          data[i].location,
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
        $(".users_content").show()
        $(".bookings_content").hide()
        $("#lisps_content").hide()
      else if $(this).text() == "Bookings"
        $(".users_content").hide()
        $(".bookings_content").show()
        $("#lisps_content").hide()
      else if $(this).text() == "LISP"
        $(".users_content").hide()
        $(".bookings_content").hide()
        $("#lisps_content").show()
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

