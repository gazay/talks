require 'yaml'

module Talks
  class Configuration

    DEFAULT_VOICES = {
      :say => {
        :info    => 'vicki',
        :warn    => 'whisper',
        :success => 'vicki',
        :error   => 'bad'
      },
      :espeak => {
        :info    => 'en+f3',
        :warn    => 'en+m1',
        :success => 'en+f3',
        :error   => 'en+m3'
      }
    }

    DEFAULT_MESSAGES = {
      :info    => 'Information note',
      :warn    => 'Warning',
      :success => 'Success',
      :error   => 'Error'
    }

    attr_accessor :voices, :messages, :default_voice, :options, :engine, :notifier

    def initialize(opts)
      @options = symbolize_hash_keys(opts)
      @engine = options[:engine] || default_engine_for_os
      @default_voice = options[:default_voice] || default_voice_for(engine)
      @voices = options[:voices] && DEFAULT_VOICES[engine.to_sym].merge(options[:voices]) ||
        DEFAULT_VOICES[engine.to_sym]
      @messages = options[:messages] && DEFAULT_MESSAGES.merge(options[:messages]) ||
        DEFAULT_MESSAGES
    end

    def voice(type)
      voices[type] if voices.keys.include?(type)
    end

    def message(type)
      messages[type] if messages.keys.include?(type)
    end

    def talk(type)
      [message(type), voice(type)]
    end

    def default_message_for(command_name, position = :after)
      "#{command_name} task #{position == :before ? 'started' : 'ended'}"
    end

    def message_for(command_name, position = :after)
      command = command_name.to_sym
      options[command] &&
        options[command][(position == :before ? :before_message : :after_message)]
    end

    def notifier_for(command_name)
      command = command_name.to_sym
      (options[:notifier] != 'off') &&
        (
          !options[command] ||
          (options[command] &&
          (options[command][:notifier] != 'off'))
        )
    end

    def notify_message_for(command_name, position = :after)
      command = command_name.to_sym
      options[command] &&
        options[command][(position == :before ? :before_notify : :after_notify)]
    end

    def voice_for(command_name)
      command = command_name.to_sym
      options[command] &&
        options[command][:voice]
    end

    private

    def default_voice_for(talks_engine)
      case talks_engine
      when 'say'
        'vicki'
      when 'espeak'
        'en+f3'
      else
        abort "Don't know this engine now: #{talks_engine}"
      end
    end

    def default_engine_for_os
      if RUBY_PLATFORM =~ /darwin/i
        'say'
      elsif !(`which espeak`.empty?)
        'espeak'
      else
        abort 'Talks is supported on Mac OS X and linux only, but you can help with support for other OSes'
      end
    end

    def symbolize_hash_keys(opts)
      sym_opts = {}
      opts.each do |key, value|
        sym_opts[key.to_sym] = \
          value.is_a?(Hash) ? symbolize_hash_keys(value) : value
      end
      sym_opts
    end

  end
end
