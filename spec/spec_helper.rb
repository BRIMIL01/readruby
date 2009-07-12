require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'readruby'
include ReadRuby

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name)
end

Spec::Runner.configure do |config|
  
end
