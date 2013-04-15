module Talks
  module Hooks
    class AfterMessage < Talks::Hooks::Base

      class << self

        def one_dash_argv; '-am'; end
        def two_dashes_argv; '--after-message'; end
        def message_name; :after; end

      end

    end
  end
end
