# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$ ->
#    sizeContent = ->
#        newHeight=$('html').height() - $('#header').height() - $('#footer').height() + 'px'
#        $('#content').css('height', newHeight)
#    $(window).resize sizeContent
#    sizeContent



# $('#map-container').css('height', $('#footer').position().top - $('#header').css('height').replace('px',''))

#jQuery ->
#    $(window).resize ->
#        alert "Hello"

`
jQuery(function() {
    $(window).resize(function() {
        Delay(function(){
            //alert('Resize...');
            $('#map-container,#right-column').css('height', $('#footer').position().top - $('#header').css('height').replace('px',''));
        }, 500);
    });
    $('#map-container,#right-column').css('height', $('#footer').position().top - $('#header').css('height').replace('px',''));

});
`
