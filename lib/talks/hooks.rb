module Talks
  module Hooks
    class << self

      def create(args)
        engine = Talks.config.engine
        options, args = shift_options(args.dup)
        command_name = command args
        voice, before_message, after_message, before_notify, after_notify = \
          parse options, command_name

        before_hook = hook(engine, voice, before_message)
        after_hook = hook(engine, voice, after_message)
        command = args.join(' ')

        [before_notify, [before_hook, command, after_hook].join('; '), after_notify]
      end

      private

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

      def parse(options, command_name)
        voice = options['-v'] || options['--voice'] ||
          Talks.config.voice_for(command_name.to_sym) ||
          Talks.config.default_voice

        before_message = options['-bm'] || options['--before-message'] ||
          Talks.config.message_for(command_name, :before) ||
          Talks.config.default_message_for(command_name, :before)

        after_message = options['-am'] || options['--after-message'] ||
          Talks.config.message_for(command_name, :after) ||
          Talks.config.default_message_for(command_name, :after)

        before_notify = Talks.config.notifier_for(command_name) &&
          (
            options['-bn'] || options['--before-notify'] ||
            Talks.config.notify_message_for(command_name, :before) ||
            Talks.config.default_message_for(command_name, :before)
          )

        after_notify = Talks.config.notifier_for(command_name) &&
          (
            options['-an'] || options['--after-notify'] ||
            Talks.config.notify_message_for(command_name, :after) ||
            Talks.config.default_message_for(command_name, :after)
          )

        [voice, before_message, after_message, before_notify, after_notify]
      end

      def hook(engine, voice, message)
        "#{engine} -v #{voice} '#{message}'"
      end

    end
  end
end
