require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JabberJaw::Adapters::Stdio do
  
  it 'collects from standard input' do
    read, write = IO.pipe
    adapter = nil
    Thread.new { adapter = JabberJaw::Adapters::Stdio.new(read, write) }
    Thread.new do
      handler = mock('handler')
      
      adapter.listen(handler)
      handler.should_receive(:handle).once.with('message')
      write << 'message'
      write.close and read.close
    end.join
  end
end