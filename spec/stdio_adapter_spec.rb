require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JabberJaw::Adapters::Stdio do
  
  it 'collects from standard input' do
    read, write = IO.pipe
    handler = mock('handler')
    
    Thread.new(read, write, handler) do |read, write, handler|
      adapter = JabberJaw::Adapters::Stdio.new(read, write)
      adapter.listen handler
      adapter.run!
    end
    
    Thread.new(handler) do |handler|
      handler.should_receive(:handle).once.with('message')
      write << 'message'
      write.close and read.close
    end
  end
end