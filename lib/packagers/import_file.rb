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
    
    sequence = Sequencer.from_single_file(path_to_first_sequence_element)
    @sequences.push(sequence)
  end
end