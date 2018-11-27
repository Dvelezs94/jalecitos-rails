document.addEventListener("turbolinks:load", function() {
  if (window.location.href.indexOf("finance") > -1 || $(".profile-container").length || $(".my_requests").length) {
    $(".tabContent").hide(); //Hides all tab content divs.
    //if user profile, then show published as default
    if ($(".profile-container").length || $(".my_requests").length) {
      $(".tabs li:eq(0)").addClass("active").show(); //Adds the active class to the first tab li.
      $(".tabContent:eq(0)").show(); //Shows the first tab content div.
    }
    $(".tabs li")
      .prepend("<div class='arrow'></div>") //Prepends the arrow to the li in the tab menu.

      .each(function() {
        var hpos = $(this).width() / 2.2; //Gets the center (somewhat) of the li.
        $(".arrow", this).css("margin-left", hpos); //Moves the arrow to the center of the li.
      })

      .hover(function() {
          $("li:not(.active) .arrow").stop(true, true).fadeOut(); //Fades out any arrows not hovered on excluding the active tab arrow.
          $(".arrow", this).stop(true, true).fadeIn(); //Fades in the arrow for this li.
        },
        function() {
          $("li:not(.active) .arrow").stop(true, true).fadeOut(); //On hover out fades the arrow for this li. (1st line of defense)
        })

      .click(function(event) {
        event.preventDefault(); //Takes the event of a normal click away.
        $(this).stop()
          .animate({
            marginTop: "2px"
          }, 100) //Animating li like a button.
          .animate({
              marginTop: "0px"
            }, 100,
            function() {
              $(".tabs li").removeClass("active"); //Removing active class from the current li and setting it to the clicked li
              $(this).addClass("active");
              $(".tabContainer").slideUp(400); //Sliding up the container and the content at the same time.
              $(".tabContent").slideUp(400);
              $("li:not(.active) .arrow").stop(true, true).fadeOut(); //Fading out the arrow that was previously active.

              var activeTab = $("a", this).attr("href"); //Finding out which content to slide down now and doing so.
              $(".tabContainer").delay(2).slideDown(1, function() { //This is setup this way for a smooth transition between tabs.
                $(activeTab).slideDown(400);
              });
              $(".tabs li.active .arrow").fadeIn(); //Fade in the newly appointed active arrow.
              return false; //Just for extra mesures.
            });
      });


    $(".tabs li:not(.active) .arrow").hide(); //Hides all arrows except the active tab arrow on page load.

    //show the correct table on finance
    if (window.location.href.indexOf("finance") > -1) {
      urlParams = new URLSearchParams(location.search);
      table = urlParams.get('table');
      if (table != null) {
        $("a[href='#" + table + "']").click();
      }
    }
  }
});
