$(document).ready(function() {
  $(".news-item").each(function() {
    var newsItem = $(this);

    newsItem.find(".thumb").mouseover(function() {
      newsItem.find(".popup").show();
    });
    
    newsItem.find(".thumb").mouseout(function() {
      newsItem.find(".popup").hide();
    });
  });
});