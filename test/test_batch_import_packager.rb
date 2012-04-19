require 'test/unit'
require File.dirname(__FILE__) + "/../lib/batch_import_packager"

class BasicTest < Test::Unit::TestCase
  def test_basic
    p = BatchImportPackager.new(File.dirname(__FILE__) + "/GW_IMPORT.batch")
    assert_equal '[#<Intense_Beauty_V09.mov>, #<Scene_hyena.[1..650].jpg>]', p.sequences.inspect
  end
  
  def test_collect
    p = BatchImportPackager.new(File.dirname(__FILE__) + "/GW_IMPORT.batch")
    p.pack_imports!('/tmp', dry_run = true)
  end
end