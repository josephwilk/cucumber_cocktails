require 'cucumber/rake/task'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format progress"
end