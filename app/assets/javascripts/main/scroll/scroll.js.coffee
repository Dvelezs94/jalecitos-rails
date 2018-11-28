$(document).on "turbolinks:load", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 600
        $('.pagination:visible').text("Cargando más coincidencias")
        $.getScript(url)
    $(window).scroll()
