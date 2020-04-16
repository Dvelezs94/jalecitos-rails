$(document).on "turbolinks:load", ->
  #pagination in most pages
  if $('.pagination').length && ! $('#contacts-list').length
    $("#searchList").scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $("#searchList").scrollTop() > $("#searchList")[0].scrollHeight - screen.height
        $('.pagination:visible').text("")
        $(".loading").show()
        $.getScript url

    $(window).scroll()

    $(window).scroll ->
      url = $('a.next-page:visible').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 300
        $('.pagination:visible').text("")
        $(".loading").show()
        $.getScript url

        $(window).scroll()

  #special pagination in messages
  else
    $("#contacts-list").scroll ->
      url = $(this).find('a.next-page').attr('href')
      if url && this.scrollHeight - $(this).scrollTop() < $(this).height() * 1.5 #the visible part is the height
        $(this).find('.pagination:visible').text("")
        $(this).find(".loading").show()
        $.getScript url
    $(".message_view_box").scroll ->
      url = $(this).find('a.next-page').attr('href')
      if url && $(this).scrollTop() < 100
        $(this).find('.pagination:visible').text("")
        $(this).find(".loading").show()
        $.getScript url
    $("#contacts-list").scroll()
