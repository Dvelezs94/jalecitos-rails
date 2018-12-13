jQuery ->
  if $("#new_image").length
    $("#new_image").fileupload
      dataType: "script"
      add: (e, data) ->
        $(".loading").show()
        data.submit()
