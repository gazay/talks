require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

desc 'Run all tests by default'
task :default do
  system("rspec spec")
end

desc 'Run if you want to hear all types of Talks.say'
task :all do
  require File.expand_path('../lib/talks.rb', __FILE__)

  Talks.voices.each do |v|
    p v
    Talks.say 'Tests start', :voice => v
  end

  p 'say `say`'
  Talks.say 'say'
  p 'info `say again`'
  Talks.info 'say again'
  p 'warn `I warn you`'
  Talks.warn 'I warn you'
  p 'error `This is how error sounds`'
  Talks.error 'This is how error sounds'
  p 'success `This is success!`'
  Talks.success 'This is success!'
  p 'info `default`'
  Talks.info
  p 'warn `default`'
  Talks.warn
  p 'warn `error`'
  Talks.error
  p 'warn `success`'
  Talks.success
end
