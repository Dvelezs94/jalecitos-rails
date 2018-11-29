$(document).on "turbolinks:load", ->
  #pagination in most pages
  if $('.pagination').length && ! $('.message_view_box').length
    $(window).scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 600
        $('.pagination:visible').text("Cargando más coincidencias")
        $.getScript(url)
    $(window).scroll()
  #special pagination in messages
  else if $('.message_view_box').length
    $(".message_view_box").scroll ->
      url = $('a.next-page').attr('href')
      if url && $(".message_view_box").scrollTop() < 100
        $('.pagination').text("Cargando más mensajes")
        $.getScript(url)
