jQuery ->
  if $("#new_image").length
    #initialize variable
    window.sentImages = 0
    #initialize file upload
    $("#new_image").fileupload
      dataType: "script"
      add: (e, data) ->
        #waiting 1 more response
        window.sentImages +=1
        #show loading
        $(".loading").show()
        data.submit()
