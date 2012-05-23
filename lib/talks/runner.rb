# What file is used for talks startup configuration.
unless defined?(OPTS_INITFILE)
  if RUBY_PLATFORM =~ /mswin/
    # Of course MS Windows has to be different
    OPTS_INITFILE = 'talks.ini'
    HOME_DIR =  (ENV['HOME'] ||
    ENV['HOMEDRIVE'].to_s + ENV['HOMEPATH'].to_s).to_s
  else
    OPTS_INITFILE = '.talksrc'
    HOME_DIR = ENV['HOME'].to_s
  end
end

initfile = File.join(HOME_DIR, OPTS_INITFILE)

if File.exist?(initfile)
  Talks.configure(YAML.load_file(initfile))
else
  Talks.configure({})
end
