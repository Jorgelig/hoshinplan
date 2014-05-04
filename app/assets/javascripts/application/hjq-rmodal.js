/* rmodal */
(function($) {
    var methods = {
        init: function(annotations) {
		$(this).click(methods.click);
        },
        click: function (event) {
		var that=$(this);
		var annotations=that.data('rapid')['rmodal'];
		var id = annotations.target_id;
		var url = annotations.url;
		var target = $('#' + id);
		if (target.length==0 || target.children().length == 0) {
			if (target.length==0) {
				that.after('<div class="modal hide" data-rapid="{&quot;modal&quot;:{}}" id="'+id+'" role="dialog" tabindex="-1"><div class="modal-body"><div class="loading"></div></div></div>')
				target = $('#' + id);
			}
			target.load(url, {'page_path':window.location.pathname}, function() {
				var that = $(this);
				that.hjq('init');
				that.trigger('rapid:ajax:success', [that]);
				that.trigger('rapid:ajax:complete', [that]);
			}); 
		}
		target.modal('show'); 
		return false;
	}
    };

    $.fn.hjq_rmodal = function( method ) {

        if ( methods[method] ) {
            return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof method === 'object' || ! method ) {
            return methods.init.apply( this, arguments );
        } else {
            $.error( 'Method ' +  method + ' does not exist on hjq_click_editor' );
        }
    };

})( jQuery );