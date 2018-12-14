jQuery ->
  if $("#new_image").length
    #initialize variable
    window.sentImages = 0
    #initialize file upload
    $("#new_image").fileupload(
      dataType: "script"

      fail: (e, data) ->
        #decrement one ajax
        ajaxRecieved()
        #show alert
        alert("Algo salió mal. Por favor, inténtalo de nuevo.")
        #hide loading if is the last
        if window.sentImages == 0
          $(".loading").hide()

      add: (e, data) ->
        types = /(\.|\/)(jpe?g|png)$/i
        file = data.files[0]
        #validate type of image
        if types.test(file.type) || types.test(file.name)
          #check size
          if file.size <= 10485760 #10 MB
            #waiting 1 more response
            ajaxSent()
            #show loading
            $(".loading").show()
            data.submit()
          else
            alert("El tamaño máximo por imagen no debe exceder de 10MB")
        else
          alert("Sólo se admiten imágenes jpg, jpeg, o png")
      )
