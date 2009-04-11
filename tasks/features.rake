require 'cucumber/rake/task'

class BuildFailure < Exception;
  def initialize(message = nil)
    message ||= "Build failed"
    super(message)
  end
end;

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format progress"
end

namespace :features do
  desc "Run finished features"
  Cucumber::Rake::Task.new(:finished) do |t|
    t.cucumber_opts = "--format progress --tags ~in-progress"
  end

  desc "Run in-progress features"
  Cucumber::Rake::Task.new(:in_progress) do |t|  
    t.cucumber_opts = "--require formatters/ --format Cucumber::Formatter::InProgress --tags in-progress"  
  end
end

desc "Run complete feature build"
task :cruise do
  finished_successful = run_finished_features
  in_progress_successful = run_in_progress_features

  unless finished_successful && in_progress_successful
    puts
    puts("Finished features had failing steps") unless finished_successful
    puts("In-progress Scenario/s passed when they should fail or be pending") unless in_progress_successful
    puts
    raise BuildFailure
  end
end

def run_in_progress_features
  puts "*** In-progress features ***"
  begin
    Rake::Task['features:in_progress'].invoke
  rescue Exception => in_progress_exception
    return false
  end
  true
end

def run_finished_features
  puts "*** Finished features ***"
  begin
    Rake::Task['features:finished'].invoke
  rescue Exception => finished_exception
    return false
  end
  true
end
