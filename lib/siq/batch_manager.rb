using SIQExtensions

module SIQ
  # Manages caching and fetching for a certain type of child object.
  class BatchManager
    # @return [Hash] current fetch options
    attr_reader :fetch_options

    # @param klass [SIQObject] The child class that's being fetched, such as {Account} or {List}
    # @param opts [Hash] fetch options
    def initialize(klass, opts = {})
      @klass = klass
      raise(SIQError, 'Must pass a SIQ Class') unless @klass.ancestors.include?(SIQ::SIQObject)
      @fetch_options = {}
      reset_cache
      
      # cause otherwise it's a variable
      self.send(:fetch_options=, opts)
      @client = SIQ.client
    end

    # Iterator for each item in the manager. Pass a block to it!
    # @example
    #   SIQ.lists.each do |l|
    #     puts l
    #   end
    def each(&blok)
      reset_cache
      loop do
        x = next_item
        if x
          blok.call(x)
        else
          return
        end
      end
    end

    # Returns the first child object, mainly used for testing
    # @return [SIQObject]
    def first
      reset_cache
      o = fetch_options.dup
      self.send(:fetch_options=, {_limit: 1})
      r = fetch_page.first
      self.send(:fetch_options=, o)
      r
    end

    # Set fetch options
    # @param opts [Hash] Where values are either strings or arrays
    def fetch_options=(opts = {})
      # these need to be updated with API changes
      valid_keys = [:_ids, :_start, :_limit, :contactIds, :accountIds, :modifiedDate]
      reset_cache
      options = {}
      opts.each do |k, v|
        # some args are comma-separated arrays, some are just args
        warn("[WARN] key #{k} is not one of #{valid_keys} and won't do anything") unless valid_keys.include?(k.to_sym)
        if v.is_a? Array
          options[k.to_sym] = v.join(',')
        else
          options[k.to_sym] = v
        end
      end
      # ruby says that nil is an argument and page_size was getting set to 0
      options[:_limit] ||= 200
      @fetch_options.merge! options#.to_cam
    end

    private
    def reset_cache
      # shouldn't reset options, that's silly
      # @fetch_options = {}
      @cache = []
      @cache_index = 0
      @page_index = 0
    end

    def next_item
      if @cache_index == @cache.size
        return nil if ![0, @fetch_options[:_limit]].include? @cache.size
        # puts "\n=== fetching page! (#{@page_index}) (#{@fetch_options[:_limit]})"
        @cache = fetch_page(@page_index)
        @page_index += @cache.size
        @cache_index = 0
      end

      if @cache_index < @cache.size
        obj = @cache[@cache_index]
        @cache_index += 1
        obj
      else
        nil
      end
    end

    def fetch_page(index = 0)
      @fetch_options.merge!({_start: index})

      # all class#node functions can take an arg, so far, only list items need it. 
      # having list_id usually be nil (that is, undefined) is fine. probably.
      data = @client.get(@klass.node(@list_id), options: @fetch_options)

      objects = []
      data.fetch('objects', []).each do |obj|
        objects << @klass.new(obj)
      end
      objects
    end
  end

  class << self
    # @!macro [new] conv
    #   Returns an iterator for all $0
    #   @return [BatchManager] 

    # @macro conv
    def lists(opts = {})
      BatchManager.new(SIQ::List, opts)
    end

    # @macro conv
    def contacts(opts = {})
      BatchManager.new(SIQ::Contact, opts)
    end

    # @macro conv
    def accounts(opts = {})
      BatchManager.new(SIQ::Account, opts)
    end
  end
end
