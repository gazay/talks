# What file is used for talks startup configuration.
initfile = if File.exists?('./.talksrc')
  './.talksrc'
elsif defined?(OPTS_INITFILE)
  OPTS_INITFILE
else
  if RUBY_PLATFORM =~ /mswin/
    # Of course MS Windows has to be different
    OPTS_INITFILE = 'talks.ini'
    HOME_DIR =  (ENV['HOME'] ||
    ENV['HOMEDRIVE'].to_s + ENV['HOMEPATH'].to_s).to_s
  else
    OPTS_INITFILE = '.talksrc'
    HOME_DIR = ENV['HOME'].to_s
  end
  File.join(HOME_DIR, OPTS_INITFILE)
end


if File.exist?(initfile)
  Talks.configure(YAML.load_file(initfile))
else
  Talks.configure({})
end
