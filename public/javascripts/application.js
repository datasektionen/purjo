$(function() {
	$('.meta').each(function() {
		var distance = 31;
		var time = 250;
		var hideDelay = 500;
		
		var hideDelayTimer = null;
		
		var beingShown = false;
		var shown = false;
		
		var trigger = $('.trigger', this);
		var popup = $('.popup', this).css('opacity', 0);
		
		$([trigger.get(0), popup.get(0)]).mouseover(function () {
			if (hideDelayTimer) {
				clearTimeout(hideDelayTimer);
			}
			
			if (beingShown || shown) {
				return;
			} else {
				beingShown = true;
				
				popup.css({
					top: '45px',
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
})
