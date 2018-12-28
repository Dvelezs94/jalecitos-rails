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
    if $(".current_images").length > 0
      $(event.currentTarget).closest("div.current_img").fadeOut 500, -> @remove()
    #delete card element if configuration
    if $("#cardForm").length > 0
      $(event.currentTarget).closest("tr").fadeOut 500, -> @remove()
