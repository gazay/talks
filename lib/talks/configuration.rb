require 'yaml'

module Talks
  class Configuration

    DEFAULT_VOICES = {
      info: 'vicki',
      warn: 'whisper',
      success: 'vicki',
      error: 'bad'
    }

    DEFAULT_MESSAGES = {
      info: 'Information note',
      warn: 'Warning',
      success: 'Success',
      error: 'Error'
    }

    attr_accessor :voices, :messages, :default_voice, :options

    def initialize(opts)
      @options = symbolize_hash_keys(opts)
      @default_voice = options[:default_voice] || 'vicki'
      @voices = options[:voices] && DEFAULT_VOICES.merge(options[:voices]) ||
        DEFAULT_VOICES
      @messages = options[:messages] && DEFAULT_VOICES.merge(options[:messages]) ||
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

    private

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
