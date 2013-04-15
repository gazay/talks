module Talks
  module Hooks
    class BeforeMessage < Talks::Hooks::Base

      class << self

        def one_dash_argv; '-bm'; end
        def two_dashes_argv; '--before-message'; end

      end

    end
  end
end
