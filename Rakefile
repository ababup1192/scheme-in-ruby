task :default => :test

task :test do
  Dir.glob('./test/*-test.rb').each { |test_file|
    system "ruby #{test_file}"
  }
end
