$(function() {
  $('div.meta').each(function() {
    var trigger = $('.trigger', this);
    var popup = $('.popup', this).css('opacity', 0);

    if (trigger.length < 1 || popup.length < 1)
      return;

    var distance = 20;
    var time = 200;
    var hideDelay = 500;
    
    var hideDelayTimer = null;
    
    var beingShown = false;
    var shown = false;

    var para = popup.find('p:first')
    para.css('margin-top', (50 - para.height()) / 4);

    $([trigger.get(0), popup.get(0)]).mouseover(function () {
      if (hideDelayTimer) {
        clearTimeout(hideDelayTimer);
      }
      
      if (beingShown || shown) {
        return;
      } else {
        beingShown = true;
        
        popup.css({
          top: '-31px',
          left: '15px',
          display: 'block',
          opacity: 0
        })
        .animate({
          left: 31,
          opacity: 1
        }, time, 'swing', function() {
          beingShown = false;
          shown = true;
        });
        
        
      }
    }).mouseout(function() {
      if (hideDelayTimer) {
        clearTimeout(hideDelayTimer);
      }
      
      hideDelayTimer = setTimeout(function() {
        hideDelayTimer = null;
        
        popup.animate({
          left: 0,
          opacity: 0
        }, time, 'swing', function() {
          shown = false;
          popup.css('display', 'none');
        });
      }, hideDelay);
    });
  })

  $('.toggle').toggle(function() {
    $(this).addClass('off');
    $(this).parent().next('.toggled').hide();
  }, function() {
    $(this).removeClass('off');
    $(this).parent().next('.toggled').show();
  }).filter('.off').click();
});


$(function() {
  var tags = $('#tag_list').children();
  if (tags.size() < 16) return;
  $('<li class="toggle">Fler taggar</li>').toggle(function() {
    $(this).addClass('off');
    tags.filter(':gt(14)').hide();
  }, function() {
    $(this).removeClass('off');
    tags.filter(':gt(14)').show();
  }).insertAfter(tags.filter(':eq(14)')).click();
});

$(function() {
  // Safaris has this functionality, so let's not overwrite it
  if (!$.browser.webkit) {
    $("#search").val($("#search").attr("placeholder"));
    $("#search").addClass("inactive");
  
  
    $("#search").focus(function() {
      var searchBox = $(this);
      var placeholderValue = searchBox.attr("placeholder");
      if (searchBox.val() == placeholderValue) {
        searchBox.addClass("active");
        searchBox.removeClass("inactive");
        searchBox.val("");
      } 
    }).blur(function() {
      var searchBox = $(this);
      var placeholderValue = searchBox.attr("placeholder");
    
      if (searchBox.val() == "") {
        searchBox.addClass("inactive");
        searchBox.removeClass("active");
        searchBox.val(placeholderValue);
      }
    });
  }
})
