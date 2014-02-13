require_relative '../spec_helper'

module ApiAsserts
  def assert_success out
    out['type'].should eq 'result'
  end
end
