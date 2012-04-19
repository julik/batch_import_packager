class BatchImportPackager::GatewayImport
  attr_reader :sequences
  
  def initialize(node, setup_path)
    @sequences = []
    
    name = REXML::XPath.first(node, "Name").text
    
    setup_dir = File.join(File.dirname(setup_path), File.basename(setup_path).gsub(/\.batch$/, ''))
    
    # Pick the node by name
    mio_path = File.join(setup_dir, "%s.mio" % name)
    doc = REXML::Document.new(File.read(mio_path))
    REXML::XPath.each(doc, '//GATEWAY_NODE_ID') do | node_id_element |
      @sequences.push(extract_sequence(node_id_element.text))
    end
  end
  
  private
  
  def extract_sequence(node_text)
    sequence_name = node_text.split('@').shift
    sequence = parse_gateway_sequence_descriptor(sequence_name)
  end
  
  FRAMES_PATTERN = /\[(\d+)\-(\d+)\]/
  
  def parse_gateway_sequence_descriptor(descriptor)
    frames_padded = descriptor.scan(FRAMES_PATTERN).flatten
    
    if frames_padded.empty? # Quicktime or a single file
      return Sequencer.from_single_file(descriptor)
    end
    
    frame_range = (frames_padded[0].to_i)..(frames_padded[-1].to_i)
    first_file = descriptor.gsub(FRAMES_PATTERN, frames_padded[0])
    
    Sequencer.from_single_file(first_file)
  end
end
