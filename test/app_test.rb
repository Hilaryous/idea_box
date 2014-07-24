require 'minitest'
require 'autorun'
require 'pride'
require ''

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  
end
