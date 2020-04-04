$ ->
  $(document).on "ajax:send", "a[data-remote]", (event) ->
    #try to catch target to use in ajax functions
    window.target = event.currentTarget
    #waiting 1 more response
    ajaxSent()

  $(document).on "ajax:error", "a[data-remote]", (event) ->
    #try to catch target to use in ajax functions
    window.target = event.currentTarget
    #recieved 1 response
    ajaxRecieved(event.currentTarget)
    #notify error
    alert("Algo salió mal. Por favor, inténtalo de nuevo")

  $(document).on "ajax:success", "a[data-remote]", (event) ->
    #try to catch target to use in ajax functions
    window.target = event.currentTarget
    #recieved 1 response
    ajaxRecieved()
    #delete image element if galleries
    if $("#current_images").length > 0
      $(event.currentTarget).closest("div.current_img").fadeOut 500, -> @remove()
    #delete card element if configuration
    if $("#cardForm").length > 0
      $(event.currentTarget).closest("li.card_or_bank_object").fadeOut 500, -> @remove()

  # $('.change_user_alias').bind("ajax:success", (data) ->
  #    console.log(this)
  #    )

  $(document).on "ajax:success", ".best_in_place", (event, data, status, xhr) ->
    $.gritter.add({ image: '/assets/success.png', title: 'Éxito', text: 'Tu ' + $(this).data('name') + " se ha actualizado" });

  $(document).on "ajax:error", ".best_in_place", (event, data, status, xhr) ->
    errors = JSON.parse(data.responseText)
    $.gritter.add({ image: '/assets/error.png', title: 'Error', text: errors[0] });



  #reload page when mobile change location is successful
  $(document).on "ajax:success", "#mobile_autocomplete", (event, data) ->
    location.reload();
  #update bank and card forms name when it is changed
  $(document).on "ajax:success", "#change_user_name", (event, data) ->
    new_name = $(this).html()
    $("#holder_name").val(new_name)
    $("#bank_holder_name").val(new_name)
    #if card or bank form was before the name changed, then open modal again
    if window.bank_after_rename
      $("#bankModal").show()
      $("#clabe").focus()
    else if window.card_after_rename
      $("#cardModal").show()
      $("#card_number").focus()
