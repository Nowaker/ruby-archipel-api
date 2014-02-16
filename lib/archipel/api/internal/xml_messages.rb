require 'action_view'

module Archipel::Api::Internal::XmlMessages
  protected
  def render template, **values
    current_dir = File.dirname __FILE__
    templates_dir = "#{current_dir}/xml/#{subdir}"
    template_file = "#{template}.xml.erb"
    ActionView::Base.new(templates_dir).render \
        file: template_file,
        locals: values
  end

  def subdir
    self.class.name.match('Archipel::Api::Internal::(.*)XmlMessages')[1].downcase
  end

  def generate_password length
    # http://stackoverflow.com/a/88341/504845
    chars = [('a'..'z'), ('A'..'Z'), ('0' .. '9')].map { |i| i.to_a }.flatten
    (0...length).map { chars[rand(chars.length)] }.join
  end
end
