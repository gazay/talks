require 'simplecov'
SimpleCov.start

OPTS_INITFILE = 'spec/test_data/talksrc'
require 'talks'

def talk_command
  Talks.config.engine
end

describe Talks do

  it 'has default methods' do
    [:add_hooks, :info, :error, :success, :warn, :say, :config].each do |method|
      expect(Talks.instance_methods.map(&:to_s)).to include(method.to_s)
    end
  end

  describe '#config' do

    it 'loads initfile' do
      expect(Talks.config.options).to_not be_empty
    end

    it 'loads default values from initfile' do
      expect(Talks.config.default_voice).to eq('agnes')
    end

    it 'contains default values for voices and messages' do
      expect(Talks.config.voices.keys).to_not be_empty
      expect(Talks.config.messages.keys).to_not be_empty
    end

    it 'returns voice for type' do
      expect(Talks.config.voice(:info)).to eq('vicki') if talk_command == 'say'
      expect(Talks.config.voice(:info)).to eq('en+f3') if talk_command == 'espeak'
    end

    it 'returns message for type' do
      expect(Talks.config.message(:info)).to eq('Information note')
    end

    it 'returns message for command if it is in .talksrc' do
      expect(Talks.config.message_for(:bundle, :before)).to eq('Bundle before message')
      expect(Talks.config.message_for(:bundle, :after)).to eq('Bundle after message')
    end

    it 'returns voice for command if it is in .talksrc' do
      expect(Talks.config.voice_for(:bundle)).to eq('bad')
    end

    it 'returns default message for command' do
      expect(Talks.config.default_message_for(:bundle, :before)).to eq('bundle task started')
      expect(Talks.config.default_message_for(:bundle, :after)).to eq('bundle task ended')
    end

  end

  context 'hooks' do

    it 'creates hooks for any command by default' do
      expect(Talks.add_hooks(['ls'])).to eq([
        "ls task started",
        "#{talk_command} -v agnes 'ls task started'; ls; #{talk_command} -v agnes 'ls task ended'",
        "ls task ended"
      ])
    end

    it 'creates preconfigured hooks for command from .talksrc' do
      expect(Talks.add_hooks(['bundle'])).to eq([
        "bundle task started",
        "#{talk_command} -v bad 'Bundle before message'; bundle; #{talk_command} -v bad 'Bundle after message'",
        "bundle task ended"
      ])
    end

    it 'changes voice if option sended' do
      expect(Talks.add_hooks(['-v', 'vicki', 'ls'])).to eq([
        "ls task started",
        "#{talk_command} -v vicki 'ls task started'; ls; #{talk_command} -v vicki 'ls task ended'",
        "ls task ended"
      ])
    end

    it 'changes before message if option sended' do
      expect(Talks.add_hooks(['-bm', 'test', 'ls'])).to eq([
        "ls task started",
        "#{talk_command} -v agnes 'test'; ls; #{talk_command} -v agnes 'ls task ended'",
        "ls task ended"
      ])
    end

    it 'changes after message if option sended' do
      expect(Talks.add_hooks(['-am', 'test', 'ls'])).to eq([
        "ls task started",
        "#{talk_command} -v agnes 'ls task started'; ls; #{talk_command} -v agnes 'test'",
        "ls task ended"
      ])
    end

    it 'creates hooks for command inside `bundle exec` by default' do
      expect(Talks.add_hooks(['bundle', 'exec', 'ls'])).to eq([
        "ls task started",
        "#{talk_command} -v agnes 'ls task started'; bundle exec ls; #{talk_command} -v agnes 'ls task ended'",
        "ls task ended"
      ])
    end

  end

  describe "#say" do
    it "executes command with single quotes" do
      expect(Talks).to receive(:system)
      Talks.say "I'm talking like a boss"
    end

    it 'shows notification if :notify => true option passed' do
      expect(Talks).to receive(:system)
      expect(Talks).to receive(:notify).with('Hello there!')
      Talks.say 'Hello there!', :notify => true
    end

    it 'not detaches say process if detach: false option passed' do
      Talks.config.detach = nil
      expect(Talks).to receive(:system).with(/!$/)
      Talks.say 'Hello there!'
    end

    it 'detaches say process if :detach => true option passed' do
      expect(Talks).to receive(:system).with(/\s&$/)
      Talks.say 'Hello there!', :detach => true
    end
  end

  describe '#notify' do
    it 'shows growl notification with default title' do
      expect(Notifier).to receive('notify').with({ :message => 'Hello there!' }.merge Talks.config.notifier_options)
      Talks.notify 'Hello there!'
    end

    it 'uses passed options' do
      expect(Notifier).to receive('notify').with(:message => 'Hello there!', :title => 'Hello?', :image => 'icon.ico')
      Talks.notify 'Hello there!', :title => 'Hello?', :image => 'icon.ico'
    end
  end

end
