require 'test/unit'
require File.dirname(__FILE__) + "/../lib/batch_import_packager"

class BasicTest < Test::Unit::TestCase
  def test_basic
    p = BatchImportPackager.new(File.dirname(__FILE__) + "/GW_IMPORT.batch")
  end
end