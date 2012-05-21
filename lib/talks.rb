module Talks
  class << self

    VOICES = %w(
      Agnes Albert Alex Bad Bahh Bells Boing Bruce Bubbles Cellos
      Deranged Fred Good Hysterical Junior Kathy Pipe Princess Ralph
      Trinoids Vicki Victoria Whisper Zarvox
    )

    PREFS = {
      info: 'Bruce',
      warn: 'Whisper',
      success: 'Fred',
      error: 'Trinoids'
    }

    def voice
      @voice ||= :info
    end

    def voice=(voice = :info)
      @voice ||= voice
    end

    def say(message, type = voice, options = {})
      type = type.to_sym
      say_voice = \
        if options[:voice] and VOICES.include?(options[:voice].to_downcase)
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
