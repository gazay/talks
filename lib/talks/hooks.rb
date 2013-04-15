require File.expand_path('../hooks/base', __FILE__)
require File.expand_path('../hooks/voice', __FILE__)
require File.expand_path('../hooks/before_message', __FILE__)
require File.expand_path('../hooks/after_message', __FILE__)
require File.expand_path('../hooks/before_notify', __FILE__)
require File.expand_path('../hooks/after_notify', __FILE__)

module Talks
  module Hooks
    class << self


      def create(args)
        options, args = shift_options(args.dup)
        command_name = command args
        voice, before_message, after_message, before_notify, after_notify = \
          parse options, command_name

        before_hook = hook(voice, before_message)
        after_hook = hook(voice, after_message)
        command = args.join(' ')

        [before_notify, [before_hook, command, after_hook].join('; '), after_notify]
      end

      private

      def engine
        Talks.config.engine
      end

      def shift_options(args, options={})
        # Check arguments for talks
        # one-two dashed. -v or --voice
        if args.first =~ /^-{1,2}[\w-]+$/
          options[args[0]] = args[1]
          args.shift(2)
          shift_options(args, options)
        else
          [options, args]
        end
      end

      def command(args)
        if args[0..1] == %w(bundle exec)
          args[2]
        else
          args[0]
        end
      end

      def parse(opts, cmd)
        voice = Talks::Hooks::Voice.to_hook opts, cmd

        before_message = Talks::Hooks::BeforeMessage.to_hook opts, cmd

        after_message = Talks::Hooks::AfterMessage.to_hook opts, cmd

        before_notify = Talks.config.notifier_for(cmd) &&
          Talks::Hooks::BeforeNotify.to_hook(opts, cmd)

        after_notify = Talks.config.notifier_for(cmd) &&
          Talks::Hooks::AfterNotify.to_hook(opts, cmd)

        [voice, before_message, after_message, before_notify, after_notify]
      end

      def hook(voice, message)
        "#{engine} -v #{voice} '#{message}'"
      end

    end
  end
end
