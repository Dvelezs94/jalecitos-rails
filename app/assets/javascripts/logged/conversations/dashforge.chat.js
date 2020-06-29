$(document).on('turbolinks:load', function() {
  if ($(".chat-sidebar-body").length > 0) { //means im in conversations path
    $('[data-toggle="tooltip"]').tooltip();

    // chat sidebar body scrollbar
    new PerfectScrollbar('.chat-sidebar-body', {
      suppressScrollX: true
    });
    if ($(".chat-content-body").length > 0) { //maybe conversation path is open without a conversation
    // chat content body scrollbar
    new PerfectScrollbar('.chat-content-body', {
      suppressScrollX: true
    });
    showChatContent(); //if opens conversations with chat opened, fixes bug of responsive chat open
    }

    ///// UI INTERACTION /////

    // channel click
    $('#allChannels a').on('click', function(e) {
      e.preventDefault()
      $(this).addClass('active');
      $(this).siblings().removeClass('active');

      $('[contacts-list] .active').removeClass('active');

      // view channel nav icon
      $('#channelNav').removeClass('d-none');
      $('#directNav').addClass('d-none');

      if (window.matchMedia('(max-width: 991px)').matches) {
        showChatContent();
      }
    })

    // direct message click
    $('[contacts-list] .media').on('click', function(e) {
      e.preventDefault();
      $(this).addClass('active');
      $(this).siblings().removeClass('active');

      $('#allChannels .active').removeClass('active');

      var avatar = $(this).find('.avatar');

      // view direct nav icon
      $('#channelNav').addClass('d-none');
      $('#directNav').removeClass('d-none');

      if (window.matchMedia('(max-width: 991px)').matches) {
        showChatContent();
      }

      $('body').removeClass('show-sidebar-right');
      $('#showMemberList').removeClass('active');

    })


    $('#showMemberList').on('click', function(e) {
      e.preventDefault()
      $(this).toggleClass('active');
      $('body').toggleClass('show-sidebar-right');
    })

    $('#chatContentClose').on('click', function(e) {
      e.preventDefault()
      hideChatContent();
    })

    // making sure navleft and sidebar are display when resizing to desktop
    $(window).resize(function() {
      if (window.matchMedia('(min-width: 992px)').matches) {
        $('.chat-navleft').removeClass('d-none');
        $('.chat-sidebar').removeClass('d-none');
      }
    })
  }
});

function showChatContent() {
  $('#mainMenuOpen').addClass('d-none');
  $('#chatContentClose').removeClass('d-none');

  $('body').addClass('chat-content-show');
}

function hideChatContent() {
  $('#chatContentClose').addClass('d-none');
  $('#mainMenuOpen').removeClass('d-none');

  $('body').removeClass('chat-content-show');
}
