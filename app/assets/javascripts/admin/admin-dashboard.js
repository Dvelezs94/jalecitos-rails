document.addEventListener("turbolinks:load", function() {

    $('#sidebarCollapse').on('click', function () {
        $('#sidebar').toggleClass('active');
        $('#content').toggleClass('change');
    });

});
