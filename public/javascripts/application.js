// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var justifyHeight = function(){
    jQuery(function($){
        var left = $("div#leftcolumn").height();
        var right = $("div#rightcolumn").height();
        var min = $("div#leftcolumn").css("min-height").match(/(\d+)px/)[1];
        min = (new Number(min)).valueOf();
        if (min < left || min < right){
            if (left < right){
                $("div#leftcolumn").css("min-height", right);
            }
            if (right < left){
                $("div#rightcolumn").css("min-height", left);
            }
        }
    });
};

