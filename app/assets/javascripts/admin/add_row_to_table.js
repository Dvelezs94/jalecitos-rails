$(document).on('turbolinks:load', function() {
      $(".add-row").click(function(){
          var row_key = $("#row-key").val();
          var row_value = $("#row-value").val();
          var markup = "<tr><td><input type='checkbox' name='record'></td><td>" + row_key + "</td><td>" + row_value + "</td></tr>";
          $("#filters tbody").append(markup);

          // update filters value
          var filters = JSON.parse($("#marketing_notification_filters").val());
          filters[row_key] = row_value;
          $("#marketing_notification_filters").val(JSON.stringify(filters));
      });

      // Find and remove selected table rows
      $(".delete-row").click(function(){
          $("#filters tbody").find('input[name="record"]').each(function(){
            if($(this).is(":checked")){
                  $(this).parents("tr").remove();
              }
          });
      });
});
