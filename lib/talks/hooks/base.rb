module Talks
  module Hooks
    class Base
      class << self

        def one_dash_argv; ''; end
        def two_dashes_argv; ''; end
        def message_method; :message_for; end
        def default_message_method; "default_#{message_method}"; end
        def message_name; :before; end

        def to_hook(opts, cmd)
          opts[one_dash_argv] ||
            opts[two_dashes_argv] ||
            Talks.config.send(message_method, cmd, message_name) ||
            Talks.config.send(default_message_method, cmd, message_name)
        end

      end
    end
  end
end
