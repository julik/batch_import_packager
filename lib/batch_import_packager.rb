#!/usr/bin/env ruby

require "rexml/document"
require 'sequencer'
require 'progressbar'
require "fileutils"

class BatchImportPackager
  
  VERSION = '1.0.0'
  
  attr_reader :sequences
  
  def self.collect(dir_path, destination)
    glob = File.join(dir_path, "**", "*.batch")
    new(Dir.glob(glob)).pack_imports!(destination)
  end
  
  def initialize(*batch_file_paths)
    @sequences = []
    batch_file_paths.flatten.map(&method(:collect_imports))
  end
  
  def detect_all_imports!
    batch_files.each(&method(:collect_imports))
  end
  
  def pack_imports!(destination, dry_run = false)
    check_destination!(destination)
    
    # Prep the copy
    all_the_files = @sequences.map{|s| s.to_paths }.flatten.uniq
    puts "=== WILL COPY %d FILES ===" % all_the_files.length
    
    pbar = ProgressBar.new("Copying", all_the_files.length, $stderr)
    all_the_files.each do | path |
      pbar.inc
      begin
        run_copy(path, destination + '/') unless dry_run
      rescue Errno::ETIMEDOUT => e
        sleep 1
        retry
      end
    end
    pbar.finish
  end
  
  # Executes the copy
  def run_copy(path, destination_directory_with_trailing_slash)
    FileUtils.cp(path, destination_directory_with_trailing_slash)
  end
  
  private
  
  def check_destination!(destination)
    raise "Destination directory #{destination} does not exist" unless File.exist?(destination)
    raise "Destination #{destination} is not a directory" unless File.directory?(destination)
  end
  
  def display_sequence(seq)
    sequences.each do | seq |
      puts "--> Found linked sequence #{seq.inspect}"
    end
  end
  
  def collect_imports(setup_path)
    puts "Collecting imports from #{setup_path}"
    
    doc = REXML::Document.new(File.read(setup_path))
    
    # Find all the Node nodes that we support and extract their related sequences
    supported_nodes = self.class.constants.map{|const| const.to_s }
    supported_nodes.each do | node_type |
      REXML::XPath.each(doc, '//Node/Type' ) do | type_node |
        if type_node.text == node_type
          packager_class = self.class.const_get(node_type)
          more_sequences = packager_class.new(type_node.parent, setup_path).sequences.compact
          add_sequences(more_sequences)
        end
      end
    end
  end
  
  def add_sequences(extra_sequences)
    extra_sequences.each do | seq |
      @sequences.push(seq) unless @sequences.include?(seq)
    end
  end
end

packagers_dir = File.dirname(File.expand_path(__FILE__)) + '/packagers'
Dir.glob(packagers_dir + '/*.rb').each do | packager_file |
  require packager_file
end