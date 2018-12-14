$ ->
  $(document).on "ajax:send", "a[data-remote]", (event) ->
    #waiting 1 more response
    ajaxSent()
    #show loading
    $(".loading").show()

  $(document).on "ajax:error", "a[data-remote]", (event) ->
    #recieved 1 response
    ajaxRecieved()
    #if all responses recieved, hide loading
    if window.sentImages==0
      $(".loading").hide()
    #notify error
    alert("Algo salió mal. Por favor, inténtalo de nuevo")

  $(document).on "ajax:success", "a[data-remote]", (event) ->
    #recieved 1 response
    ajaxRecieved()
    #if all responses recieved, hide loading
    if window.sentImages==0
      $(".loading").hide()
    #delete element in html
    $(event.currentTarget).closest("div.current_img").fadeOut 500, -> @remove()
