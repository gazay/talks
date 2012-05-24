module Talks
  module Hooks
    class << self

      def create(args)
        engine = check_engine
        options, args = shift_options(args.dup)
        command_name = command args
        voice, before_message, after_message = parse options, command_name

        before_hook = hook(engine, voice, before_message)
        after_hook = hook(engine, voice, after_message)
        command = args.join(' ')

        [before_hook, command, after_hook].join('; ')
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

      def check_engine
        if RUBY_PLATFORM =~ /darwin/i
          'say'
        else
          abort 'Now talks can work only on MacOS X, you can help with support other OS'
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

        [voice, before_message, after_message]
      end

      def hook(engine, voice, message)
        if engine == 'say'
          "say #{message} -v #{voice}"
        else
          abort 'Now you can use talks gem only on mac with say'
        end
      end

    end
  end
end