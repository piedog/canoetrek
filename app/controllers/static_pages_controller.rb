class StaticPagesController < ApplicationController
  def map
    gon.myobject = { msg: 'hello world' }
  end

  def home
  end
end
