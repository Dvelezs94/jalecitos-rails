jQuery ->
  if $("#user_image").length
    #initialize file upload
    $("#user_image").fileupload(
      dataType: "script"

      fail: (e, data) ->
        #decrement one ajax
        ajaxRecieved()
        #show alert
        alert("Algo salió mal. Por favor, inténtalo de nuevo.")

      done: (e, data) ->
        location.reload();
      )