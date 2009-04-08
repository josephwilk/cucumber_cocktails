require 'cucumber/rake/task'

class FeatureFailure < Exception; end;
 
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
    t.cucumber_opts = "--format Cucumber::Formatter::InProgress --strict --tags in-progress"
  end
end

desc "Run complete feature build"
task :cruise do
  finished_successful = run_finished_features
  in_progress_successful = run_in_progress_features

  puts("Finished features had failing steps") unless finished_successful
  puts("In-progress Scenario/s passed when they should fail or be pending") if in_progress_successful
  raise FeatureFailure if !finished_success || in_progress_successful
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
