$(document).on "turbolinks:load", ->
  #pagination in most pages
  if $('.pagination').length && ! $('.messages-list').length
    $(window).scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 600
        $('.pagination:visible').text("Cargando más coincidencias")
        $.getScript(url)
    $(window).scroll()
  #special pagination in messages
  else if $('.messages-list').length
    $(".messages-list").scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $(".messages-list").scrollTop() < 100
        $('.pagination:visible').text("Cargando más mensajes")
        $.getScript(url)
