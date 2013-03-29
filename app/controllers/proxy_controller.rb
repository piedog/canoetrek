require 'net/http'
class ProxyController < ApplicationController
    def get
        url = URI.parse(params["url"])
        result = Net::HTTP.get_response(url)
        send_data :text => result.body
    #   http = Net::HTTP.new(url.host)
    end
end
