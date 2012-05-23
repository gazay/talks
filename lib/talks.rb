require File.expand_path('../talks/configuration.rb', __FILE__)

module Talks
  class << self

    VOICES = %w(
      agnes albert alex bad bahh bells boing bruce bubbles cellos
      deranged fred good hysterical junior kathy pipe princess ralph
      trinoids vicki victoria whisper zarvox
    )

    TYPES = [:info, :warn, :success, :error]

    attr :config

    def configure(options)
      @config = Talks::Configuration.new(options)
    end

    def voices
      VOICES
    end

    def say(message, options = {})
      type = options[:type] || :default
      `say -v #{say_voice(type, options)} #{message}`
    end

    TYPES.each do |type|
      define_method type do |message = nil, options = {type: type}|
        message ||= config.message(type)
        say(message, options)
      end
    end

    private

    def say_voice(type, options)
      if options[:voice] and VOICES.include?(options[:voice].to_s)
        options[:voice]
      elsif TYPES.include? type
        config.voice type
      else
        config.default_voice
      end
    end

  end
end

require File.expand_path('../talks/runner.rb', __FILE__)
