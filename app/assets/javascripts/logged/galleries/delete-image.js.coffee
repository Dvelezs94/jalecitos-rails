$ ->
  $(document).on "ajax:success", "a[data-remote]", (event) ->
    $(".loading").hide()
    $(event.currentTarget).closest("div.current_img").fadeOut 500, -> @remove()
