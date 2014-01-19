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

var attatchAutosubmit = function() {
	$(".autosubmit input[type=text]")
		.unbind("change", submitClosestForm).change(submitClosestForm);
	$('.bootstrap-datepicker').datepicker();
	$(".autosubmit").unbind("submit", preventDoubleSubmit).submit(preventDoubleSubmit);
	colorize();
}

var colorize = function () {
	$(".indicator-tpc").parent().heatcolor(
		function() {
			var num = $(this).children(".indicator-tpc").text();
			num = num>100 ? 100 : num<50 ? 50 : num;
			return num;
		}, 
		{ maxval: 100, minval: 50, colorStyle: 'greentored', lightness: 0.4 }
	);
}

$(document).ready(attatchAutosubmit);

$( window ).resize(function() {
  equalHeightSections();
});

var equalHeightSections = function() {
	equalHeights($("div.objectives-wrapper"));
	equalHeights($("div.indicators-wrapper"));
	equalHeights($("div.tasks-wrapper"));
}

var equalHeights = function(elements) {
	elements.height("auto");
	var maxHeight = Math.max.apply(null, elements.map(function ()
	{
	    return $(this).height();
	}).get());
	elements.height(maxHeight);
}