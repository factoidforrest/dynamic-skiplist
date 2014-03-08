module Threading
  #modify DSkipList by storing it as "base" when it includes this module
  def self.included(base)
    base::Node.class_eval do
      alias_method :old_initialize, :initialize
      def initialize *args#(k, v = nil)
        old_initialize *args#(k, v)
        #@mutex = Mutex.new
        #@forward = ThreadSafe::Array.new
      end
    end

    base.class_eval do
      @pool = Thread.pool(Facter.processorcount.to_i) 
      alias_method :old_insert, :insert
      def insert *args 
        #splatting could be slow
        #wrap in mutex
        old_insert *args
      end
    end
  end
end

