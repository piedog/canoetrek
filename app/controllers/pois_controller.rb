class PoisController < ApplicationController
    def index
        #@myvar = 'Hello world'
        #@msg = 'a message from rails'

        # @myobject = { button_id: "mylink", msg: "hello, using default options" }

        @button_id = "thelink"
        gon.myobject = { button_id: @button_id, msg: "hello, using override options" }
    
    end
end
