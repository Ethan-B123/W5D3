require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params)
    @req, @res = req, res
    @params = params
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    if @already_built_response.nil?
      @already_built_response = true
      nil
    else
      @already_built_response
    end
  end

  # Set the response status code and header
  def redirect_to(url)
    throw "already built response" if already_built_response?
    @res["Location"] = url
    @res.status = 302
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    throw "already built response" if already_built_response?
    @already_built_response = true
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)

    path_to_dir = "./views/#{self.class.to_s.underscore}/"
    file_name = template_name.to_s + ".html.erb"
    full_path = path_to_dir + file_name

    file_as_string = IO.readlines(full_path).inject(&:+)
    built_html = ERB.new(file_as_string).result(binding)

    render_content(built_html, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name, *args)
    self.send(name, *args)
  end
end
