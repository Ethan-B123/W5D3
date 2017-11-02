require 'json'


class Flash

  attr_accessor :now


  def initialize(req)
    if req.cookies["_rails_lite_app_flash"]
      @now.hash = JSON.parse(req.cookies["_rails_lite_app_flash"])
    else
      @now = {}
      @flash = {}
    end
  end

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end



  def store_flash(res)
    res.set_cookie("_rails_lite_app_flash", path: "/", value: @now.hash.to_json)
  end

end
