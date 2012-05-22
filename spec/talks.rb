require File.expand_path('../../lib/talks.rb', __FILE__)

Talks.voices.each do |v|
  p v
  Talks.say 'Tests start', nil, voice: v
end

Talks.say 'say'
Talks.info 'say again'
Talks.warn 'I warn you'
Talks.error 'This is how error sounds'
Talks.success 'This is success!'
