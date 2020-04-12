# $(document).on "turbolinks:load", ->
#   if $(".best_in_place").length > 0
#     $(".best_in_place").best_in_place();
#   if $("#user_image").length > 0
#     #initialize file upload
#     $("#user_image").fileupload(
#       dataType: "script"
#
#       fail: (e, data) ->
#         #decrement one ajax
#         ajaxRecieved()
#         #show alert
#         alert("Algo salió mal. Por favor, inténtalo de nuevo.")
#
#       done: (e, data) ->
#         location.reload();
#       )
