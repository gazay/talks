module Talks
  class << self

    VOICES = %w(
      agnes albert alex bad bahh bells boing bruce bubbles cellos
      deranged fred good hysterical junior kathy pipe princess ralph
      trinoids vicki victoria whisper zarvox
    )

    PREFS = {
      info: 'vicki',
      warn: 'whisper',
      success: 'vicki',
      error: 'bad'
    }

    def voice
      @voice ||= :info
    end

    def voice=(voice = :info)
      @voice ||= voice
    end

    def voices
      VOICES
    end

    def say(message, type = voice, options = {})
      type = type.to_sym if type
      say_voice = \
        if options[:voice] and VOICES.include?(options[:voice].to_s)
          options[:voice]
        elsif PREFS.keys.include? type
          PREFS[type]
        else
          PREFS[voice]
        end
      `say -v #{say_voice} #{message}`
    end

    PREFS.keys.each do |type|
      define_method type do |message, options = {}|
        say(message, type, options)
      end
    end

  end
end
