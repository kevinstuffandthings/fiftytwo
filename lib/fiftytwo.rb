# frozen_string_literal: true

require "fiftytwo/version"
require "active_support"
require "active_support/core_ext"

%w[rank suit card hand deck].each { |f| require "fiftytwo/#{f}" }

# FiftyTwo
module FiftyTwo
end
