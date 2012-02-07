var Preview = {
  textilize: function(elementId, output) {
    var html = convert(document.getElementById(elementId).value);
    document.getElementById(output).innerHTML=html;
  },

  watchTextilize: function(input, output) {
    Preview.textilize(input, output);
    $("#"+input).keyup(function(){ Preview.textilize(input, output); });
  },

  togglePreview: function(source, preview) {
    if($(preview).is(":visible")) {
      $(preview).hide();
      $(source).show();
    } else {
      $(preview).show();
      $(source).hide();
    }
  }
};
