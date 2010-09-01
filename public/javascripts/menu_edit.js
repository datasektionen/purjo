$(document).ready(function() {
  $("#menu_edit .js_show").show()
  $("#menu_edit .js_hide").hide()
  $("#menu_edit #menu_content").sortable({
    update: update_list
  });
});
function update_list() {
    items=$("#menu_edit #menu_content > li > .menu_edit_info > .menu_edit_sort >input")
    for(i=0;i<items.length;++i) {
      items[i].value=i
    }
}

/*
$(".js_delete").click(function() {
$.ajax({
data: {ajax: 'true'},
success: function(data,status,xhr,form) {
  if(data=="OK") {
    li=form.parent().parent()
    li.hide(1000, function() {
      $(this).remove()
      update_list()
    })
  }
}
});
*/
