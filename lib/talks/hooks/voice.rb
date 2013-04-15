module Talks
  module Hooks
    class Voice < Talks::Hooks::Base

      class << self

        def one_dash_argv; '-v'; end
        def two_dashes_argv; '--voice'; end

        def to_hook(opts, cmd)
          opts[one_dash_argv] || opts[two_dashes_argv] ||
            Talks.config.voice_for(cmd.to_sym) || Talks.config.default_voice
        end

      end

    end
  end
end
