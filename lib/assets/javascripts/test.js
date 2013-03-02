var RGP = {};
// ======================================//
RGP.Clickable = function() {};

RGP.Clickable.prototype = {
    options: { button_id: "default-link", msg: "hello, using default options" },
    initialize: function(options) {
        self = this;
        self.options = $.extend(self.options, options);
        $('#'+self.options.button_id).click(function() {
            alert(self.options.msg);
            return false;
        });
    }
};
