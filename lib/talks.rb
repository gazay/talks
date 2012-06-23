require File.expand_path('../talks/configuration.rb', __FILE__)
require File.expand_path('../talks/hooks.rb', __FILE__)
require 'notifier'

module Talks
  extend self

    VOICES = {
      :say => %w(
        agnes albert alex bad bahh bells boing bruce bubbles cellos
        deranged fred good hysterical junior kathy pipe princess ralph
        trinoids vicki victoria whisper zarvox
      ),
      :espeak => %w(en+m1 en+m2 en+m3 en+m4 en+m5 en+m6 en+m7
        en+f1 en+f2 en+f3 en+f4 en+f5 en+f6 en+f7
      )
    }

    TYPES = [:info, :warn, :success, :error]

    attr :config

    def configure(options)
      @config = Talks::Configuration.new(options)
    end

    def voices
      VOICES
    end

    def engine
      config.engine
    end

    def say(message, options = {})
      abort "Undefined engine: #{engine}" unless ["say","espeak"].include? engine
      type = options[:type] || :default
      `#{engine} -v #{say_voice(type, options)} "#{message}"`
    end

    def notify(message, options = {})
      Notifier.notify(:message => message, :title => 'Talks', :image => '')
    end

    def execute(command)
      before_notify, command, after_notify = command
      Talks.notify before_notify if before_notify
      system command
      Talks.notify after_notify if after_notify
    end

    def add_hooks(command)
      Talks::Hooks.create command
    end

    TYPES.each do |type|
      module_eval <<-RUBY_EVAL,__FILE__,__LINE__ + 1
        def #{type}(message = nil, options = {:type => :#{type}})
          message ||= config.message(:#{type})
          say(message, options)
        end
      RUBY_EVAL
    end

    private

    def say_voice(type, options)
      if options[:voice] and VOICES[engine.to_sym].include?(options[:voice].to_s)
        options[:voice]
      elsif TYPES.include? type
        config.voice type
      else
        config.default_voice
      end
    end

end

require File.expand_path('../talks/runner.rb', __FILE__)
