module Talks
  module Hooks
    class BeforeNotify < Talks::Hooks::Base

      class << self

        def one_dash_argv; '-bn'; end
        def two_dashes_argv; '--before-notify'; end
        def message_method; :notify_message_for; end
        def default_message_method; :default_message_for; end
        def message_name; :before; end

      end

    end
  end
end
