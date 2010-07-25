$(document).ready(function() {
  $(".news-item").each(function() {
    var newsItem = $(this);
    $(this).find(".thumb").mouseover(function() {
      newsItem.find(".popup").show();
    });
    
    $(this).find(".thumb").mouseout(function() {
      newsItem.find(".popup").hide();
    });
  });
});