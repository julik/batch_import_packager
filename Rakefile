require './lib/batch_import_packager'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.version = BatchImportPackager::VERSION
  gem.name = "batch_import_packager"
  gem.summary = "Collects Flame/Smoke Batch import node media for archiving"
  gem.description = "Will detect Import and Gateway Import nodes"
  gem.email = "me@julik.nl"
  gem.homepage = "http://github.com/julik/batch_import_packager"
  gem.authors = ["Julik Tarkhanov"]
  gem.license = 'MIT'
  gem.executables = ["package_batch_imports"]

  # Do not package invisibles
  gem.files.exclude ".*"
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
desc "Run all tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

task :default => [ :test ]