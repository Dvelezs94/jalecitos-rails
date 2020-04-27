$(document).on "turbolinks:load", ->
  #pagination in most pages
  if $('.pagination').length && ! $('[contacts-list]').length



    $(window).scroll ->
      console.log(1)
      url = $('a.next-page:visible').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 300
        $('.pagination:visible').text("")
        $(".loading").show()
        $.getScript url


  #special pagination in messages
  else
    messages_scroll()
    $("[contacts-list]").scroll ->
      url = $(this).find('a.next-page').attr('href')
      if url && this.scrollHeight - $(this).scrollTop() < $(this).height() * 1.5 #the visible part is the height
        $(this).find('.pagination:visible').text("")
        $(this).find(".loading").show()
        $.getScript url
    $("[contacts-list]").scroll()

@messages_scroll = ->
  $("[content-scrolleable]").scroll ->
   url = $(this).find('a.next-page').attr('href')
   if url && $(this).scrollTop() < 100
     $(this).find('.pagination:visible').text("")
     $(this).find(".loading").show()
     $.getScript url

@searchList_scroll = ->
   $("img").lazyload() #fixes bug of lazyload (bug makes lazyload dont detect scroll and doesnt load images)
   url = $('a.next-page:visible').attr('href')
   if url && $("#searchList").scrollTop() > $("#searchList")[0].scrollHeight - screen.height
     $('.pagination:visible').text("")
     $(".loading").show()
     $.getScript url
