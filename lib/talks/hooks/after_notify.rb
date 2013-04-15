module Talks
  module Hooks
    class AfterNotify < Talks::Hooks::Base

      class << self

        def one_dash_argv; '-an'; end
        def two_dashes_argv; '--after-notify'; end
        def message_method; :notify_message_for; end
        def default_message_method; :default_message_for; end
        def message_name; :after; end

      end

    end
  end
end
