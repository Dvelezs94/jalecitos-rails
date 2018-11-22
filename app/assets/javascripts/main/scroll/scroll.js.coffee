$(document).on "turbolinks:load", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('a.next-page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 400
        $('.pagination').text("Cargando más coincidencias")
        $.getScript(url)
    $(window).scroll()
