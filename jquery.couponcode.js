/*
 * couponCode - jQuery plugin
 *
 * Copyright (c) 2011 Grant McLean (grant@mclean.net.nz)
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 */

(function($) {

var SYMBOL_SET = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

$.fn.couponCode = function(options) {
    return this.each(function() {
        $.fn.couponCode.build(this, options);
    });
};

$.fn.couponCode.build = function(base_entry, options) {
    var $base_entry = $(base_entry);
    var wrapper    = $( $base_entry.wrap('<span class="jq-couponcode" />').parent()[0] );
    var inner      = $('<span class="jq-couponcode-inner" />');
    var self       = $.extend({}, $.fn.couponCode.defaults, options);
    self.part      = [];
    if(! self.template.match(/^([345])(?:-([345]))*$/)) {
        alert('Bad couponCode template: ' + self.template);
        return;
    }
    $.each(self.template.split('-'), function(i, field_len) {
        self.last_part = i;
        if(i > 0) {
            inner.append($('<span class="jq-couponcode-sep" />').text(self.separator));
        }
        var input = $('<input type="text" class="jq-couponcode-part" />');
        input.keypress(function(e)  {
                  setTimeout( function() { validate(input, i, field_len, e.which != 0) }, 5 );
              } )
             .focusout(function()  { validate(input, i, field_len, false) } );
        self.part[i] = {
            'field_len' : field_len,
            'input'     : input
        };
        inner.append(input);
    });
    console.log("Template looks good: ", self.template);

    wrapper.append(inner);

    function validate(input, index, field_len, focused) {
        input.removeClass('jq-couponcode-good');
        input.removeClass('jq-couponcode-bad');
        self.part[index].value = null;
        var val = input.val();
        if(val == '') { return; }
        var code = val.replace(/o/ig, '0').replace(/[il]/ig, '1').toUpperCase();
        if(code.length > field_len || code.match(/[^0-9A-HJKMNP-TV-Z]/)) {
            input.addClass('jq-couponcode-bad');
            return;
        }
        if(code.length < field_len) {
            if(! focused) {
                input.addClass('jq-couponcode-bad');
            }
            return;
        }
        var check = 0;
        var last  = field_len - 1;
        $.each(code.split(''), function(i, chr) {
            var n = SYMBOL_SET.indexOf(chr);
            if(i < last) {
                check = check * 19 + n;
            }
            else if(chr != SYMBOL_SET.charAt(check % 29)) {
                check = -1;
            }
        });
        if(check == -1) {
            input.addClass('jq-couponcode-bad');
            return;
        }
        input.addClass('jq-couponcode-good');
        self.part[index].value = code;
        if(val != code) {
            input.val(code);
        }
        if(focused && index < self.last_part) {
            self.part[index + 1].input.focus();
        }
    }

};

$.fn.couponCode.defaults = {
    template  : '5-5-5',
    separator : '-'
};

})(jQuery);
