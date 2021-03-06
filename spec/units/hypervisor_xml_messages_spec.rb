require_relative '../spec_helper'
require 'archipel/api/internal/hypervisor_xml_messages'


describe Archipel::Api::Internal::HypervisorXmlMessages do
  before do
    @api = Archipel::Api::Internal::HypervisorXmlMessages.new
  end

  it 'render the XML' do
    expect(@api.register_user 'login', 'password').to include 'login', 'password'
  end
end