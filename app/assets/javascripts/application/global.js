var submitClosestForm = function() {
	$(this)
		.closest('form')
		.submit();
	return false;
}

var preventDoubleSubmit = function(e) {  
    if (this.beenSubmitted) {
	  e.preventDefault();
      return false;
  } else {
      this.beenSubmitted = true;
	  $(this).unbind("submit").submit(preventDoubleSubmit);
  }
};

var isValidDate = function (value, userFormat) {
  var userFormat = userFormat || 'mm/dd/yyyy', // default format

  delimiter = /[^mdy]/.exec(userFormat)[0],
  theFormat = userFormat.split(delimiter),
  theDate = value.split(delimiter),

  isDate = function (date, format) {
    var m, d, y
    for (var i = 0, len = format.length; i < len; i++) {
      if (/m/.test(format[i])) m = date[i]
      if (/d/.test(format[i])) d = date[i]
      if (/y/.test(format[i])) y = date[i]
    }
    return (
      m > 0 && m < 13 &&
      y && y.length === 4 &&
      d > 0 && d <= (new Date(y, m, 0)).getDate()
    )
  }

  return isDate(theDate, theFormat)

}

var validateDate = function(formElem) {
	var inputs = $(formElem).find(".bootstrap-datepicker");
	for (var i=0; i<inputs.length; i++) {
		var inp = $(inputs[i]);
		var format = inp.attr("data-date-format");
		var value = inp.val();
		if (!isValidDate(value, format)) {
			alert("Not a valid date, the format should be: " + format);
			return false;
		}
	}
	return true;
}

$.fn.timer = function(){
	var percent = this.data("percent");
	this.html('<div class="percent"></div><div class="slice'+(percent > 50?' gt50':'')+'"><div class="pie"></div><div class="pie fill"></div></div><div class="bg"></div>');
	var deg = 360/100*percent;
	this.find('.slice .pie').css({
		'-moz-transform':'rotate('+deg+'deg)',
		'-webkit-transform':'rotate('+deg+'deg)',
		'-o-transform':'rotate('+deg+'deg)',
		'transform':'rotate('+deg+'deg)'
	});
	this.find('.percent').html(Math.round(percent)+'%');
}

$(window).load(function() {
    window.loaded = true;
});

function updateTimer() {
	if (!window.loaded) {
		$(window).load(updateTimer);
		return;
	}
	$("#health").popover('destroy');
	$("#health-popover").html("");
	with($(".timer[data-percent]")) {
		timer();
		heatcolor(
			function() {
				var num = data("percent");
				return num;
			}, 
			{ maxval: 100, minval: 0, colorStyle: 'greentored', lightness: 0.4, 
			  elementFunction: function() {return children(".percent")} });
		children(".percent").each(function() {
			var col = $(this).css("background-color");
			$(this).parent().find(".pie").css("border-color", col);
		});
		show();
	}
	$('#health').popover({
	    container: '#health-popover',
	    html: true,
	    content: function () {
	        return $(this).next().html();
	    }
	});
	$( "#health" ).click(function( event ) {
	  event.stopPropagation();
	});
	with($("#health.tutorial")) {
		if (length) {
			dimBackground();
			popover('show');
		}
	}
}

$(document).ready(function() {
	$('.popper').popover({
	    container: 'body',
	    html: true,
	    content: function () {
	        return $(this).next().html();
	    }
	});
	$('body').on('keyup.dismiss.healthPopover', function (e) {
		e.which == 27 && $('#health').popover('hide');
	});
	$('body').on('click.dismiss.healthPopover', function (e) {
		if ($('#health-popover div.popover:visible').length){
			$('#health').popover('hide');
		}
	});
});

var attachAutosubmit = function() {
	$('.bootstrap-datepicker').datepicker({orientation: "top left"});
	$(".autosubmit input[type=text]")
		.unbind("change", submitClosestForm).change(submitClosestForm);
	$(".autosubmit input.indicator-value")
		.unbind("blur", submitClosestForm).blur(submitClosestForm);
	$(".autosubmit").unbind("submit", preventDoubleSubmit).submit(preventDoubleSubmit);
	colorize();
	equalHeightSections();
	
	$("[data-rmodal]").each(function () {
		var that = $(this);
		var id = that.data('target-id');
		if ($('#' + id).length == 0 || $('#' + id).children().length == 0) {
			var url = that.data('rmodal');
			that.click(function () {
				if ($('#' + id).length==0 || $('#' + id).children().length == 0) {
					if ($('#' + id).length==0) {
						that.after('<div class="modal hide" data-rapid="{&quot;modal&quot;:{}}" id="'+id+'" role="dialog" tabindex="-1"><div class="modal-body"><div class="loading"></div></div></div>')
					}
					$('#' + id).load(url, function() {
						$('#' + id).hjq('init');
						attachAutosubmit();
					}); 
				}
				$('#' + id).modal('show'); 
				return false;
			});
		}
	});
	
	$('.in-place-edit a, .description-help a, .header-help a').filter(function() {
	   return this.hostname && getServerAndTld(this.hostname) !== getServerAndTld(location.hostname);
	}).each(function () {
		$(this).addClass("external");
		$(this).attr('target', '_blank');
		$(this).click(function (event) { event.stopPropagation(); });
	});
	
	$('.my-click-editor .in-place-edit').click(function () {
		$(this).toggle();
		$(this).next('.in-place-input').toggle();
	});
}

function getServerAndTld(host) {
	var arr = host.split(".");
	arr = arr.slice(Math.max(arr.length - 2, 0));
	return arr.join(".");
}

$(document).ready(attachAutosubmit);

function fixedHorizontal() {
	if ($("body.pdf")) { return; }
        $("body.fixed-headers .navbar, body.fixed-headers .content-header, .fixed-x").map(function() {
		$(this).css({"margin-left": "0"}); 
		$(this).css({"width": "auto"});
		$(this).css({"width": $(this).width()});
		$(this).css({"margin-left": $(window).scrollLeft()}); 
	});
}


$(window).scroll(function () {
	if (presenting) return;
        fixedHorizontal();
}); 

var colorize = function () {
	$(".indicator-tpc, .child-indicator-tpc").parent().heatcolor(
		function() {
			var num = $(this).children(".indicator-tpc, .child-indicator-tpc").text();
			var sep = document.documentElement.getAttribute('data-sep').replace('.','\\.');
			var del = document.documentElement.getAttribute('data-del').replace('.','\\.');;
			num = num.replace(new RegExp(del, 'g'), '');
			num = num.replace(new RegExp(sep, 'g'), '.');
			num = num>100 ? 100 : num<50 ? 50 : num;
			return num;
		}, 
		{ maxval: 100, minval: 50, colorStyle: 'greentored', lightness: 0.4 }
	);
}

$( window ).resize(function() {
  equalHeightSections();
});

var eh = false;

var equalHeightSections = function() {
	if (presenting) return;
	if (eh) return;
	eh = true;
	fixedHorizontal();
	equalHeights("div.objectives-wrapper");
	equalHeights("div.indicators-wrapper");
	equalHeights("div.tasks-wrapper");
	eh = false;
}

var equalHeights = function(elements) {
	$(elements).height("auto");
	if (window.matchMedia('(max-width: 640px)').matches) return;
	var maxHeight = 0;
	//$(elements).css({border: "1px solid red"});
	$(elements).each(function(){
        	//$("body").append("Hola: " + $(this).parent().attr("id") + " . " + $(this).innerHeight() + "<br/>");
    		if ($(this).height() > maxHeight) {
	 	       maxHeight = $(this).height();
		}
	});
	$(elements).height(maxHeight);
	//$(elements).height("auto");
	//$("body").append("MH: " + maxHeight + "<br/>");
	
}

var PRESENTATION_SELECTOR = '.slide-page,div.navbar,div.content-header,div.hoshin-header,.ordering-handle,.column.ordering';

var presenting = false;
var currentSlide = 1;
var sliding = false;

var navigatePrev = function() {
	var nslides = $('.slide-page').length;
	var area = currentSlide;
	if (currentSlide == 0) {
		area = nslides-1;
	} else {
		area = currentSlide-1;
	}
	slideAreas(currentSlide, area, true);
}

var navigateNext = function() {
	var nslides = $('.slide-page').length;
	var area = currentSlide;
	if (currentSlide == nslides-1) {
		area = 0;
	} else {
		area = currentSlide+1;
	}
	slideAreas(currentSlide, area, false);
}

var slideAreas = function(current, next, reverse) {
	if (current == next || sliding)
		return;
	sliding = true;
	var w = $( document ).width() + "px";
	var mw = "-" + w;
	$($('.slide-page')[next]).css({left: (reverse?mw:w)});
	$($('.slide-page')[next]).animate({left:0}, "slow").toggle();
	$($('.slide-page')[current]).animate({"left":(reverse?w:mw)}, "slow", 
		function() {
			$($('.slide-page')[current]).toggle(); 
			currentSlide = next;
			sliding = false;
		}
	);
} 

var showSlide = function(num) {
	var nslides = $('.slide-page').length;
	var slide = num;
	if (slide >= nslides) {
		slide = nslides-1;
	}
	$('.slide-page').hide();
	$($('.slide-page')[slide]).show().css({left: 0});
	currentSlide = slide;
}

var startPresentation = function() {
	$(PRESENTATION_SELECTOR).hide();
	var size = parseInt($('body').css('font-size')) + 8;
	$('body').css({'font-size': size, 'overflow-x': 'hidden'});
	$("div.objectives-wrapper,div.indicators-wrapper,div.tasks-wrapper").height("auto");
	currentSlide = $('.slide-page').length - $('div.area').length;
	currentSlide = currentSlide < 0 ? 0 : currentSlide;
	presenting = true;
	$('.slide-page').width("100%");
	$('.slide-page').css({position:'absolute', left:0, top:0, outline: '1px solid transparent'});
	showSlide(currentSlide);
}

var endPresentation = function() {
	$(PRESENTATION_SELECTOR).show();
	$('.slide-page').show();
	var size = parseInt($('body').css('font-size')) - 8;
	$('body').removeAttr('style');
	$('.slide-page').removeAttr('style');
	presenting = false;
	equalHeightSections();
}

/**
 * Handling the fullscreen functionality via the fullscreen API
 *
 * @see http://fullscreen.spec.whatwg.org/
 * @see https://developer.mozilla.org/en-US/docs/DOM/Using_fullscreen_mode
 */
function enterFullscreen() {

        var element = document.body;

        // Check which implementation is available
        var requestMethod = element.requestFullScreen ||
                                                element.webkitRequestFullscreen ||
                                                element.webkitRequestFullScreen ||
                                                element.mozRequestFullScreen ||
                                                element.msRequestFullScreen;

        if( requestMethod ) {
                requestMethod.apply( element );
        }

}

var attachKeyEvents = function() {
	$('body').keydown(function(e){
		if (!presenting) {
			return;
		}
		switch( e.which ) {
			// esc
			case 27: endPresentation(); break;
		        // left
		        case 37: navigatePrev(); break;
		        // right
		        case 39: navigateNext(); break;
		        // home
		        case 36: showSlide( 0 ); break;
		        // end
		        case 35: showSlide( Number.MAX_VALUE ); break;
		        // f
		        case 70: enterFullscreen(); break;
		}
	});
}

$(document).ready(function() {
	var domain = document.location.hostname.replace(/[^\.]*\./,'');
	var tz = $(document).get_timezone();
	document.cookie = "tz=" + tz+";domain="+domain;
});


$(document).ready(attachKeyEvents);

function cls() { return true; }

