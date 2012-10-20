# This packager helps collect the standard vanilla import nodes
class BatchImportPackager::ImportFile
  attr_reader :sequences
  
  def initialize(node, setup_path)
    @sequences = []
    
    name = REXML::XPath.first(node, "Name").text
    
    setup_dir = File.join(File.dirname(setup_path), File.basename(setup_path).gsub(/\.batch$/, ''))
    
    # Pick the node by name
    import_node_path = File.join(setup_dir, "%s.import_node" % name)
    doc = REXML::Document.new(File.read(import_node_path))
    path_to_first_sequence_element = REXML::XPath.first(doc, 'Setup/State/FileName').text
    
    @sequences.push(package_sequence(path_to_first_sequence_element))
  end
  
  def package_sequence(first_file)
    begin
      Sequencer.from_single_file(first_file)
    rescue RuntimeError
      $stderr.puts "Cannot package sequence starting at #{first_file} - no such file on filesystems!"
      nil
    end
  end
end
