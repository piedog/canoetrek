# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    sizeContent = ->
        newHeight = $('html').height() - $('#header').height() - $('#footer').height() + 'px'
        $('#content').children().css('height', newHeight)
    $(document).ready(sizeContent)
    $(window).resize(sizeContent)
    gdd = new GdD.Test()
    gdd.map.updateSize()
