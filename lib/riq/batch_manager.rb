using RIQExtensions

module RIQ
  # Manages caching and fetching for a certain type of child object.
  class BatchManager
    # @return [Hash] current fetch options
    attr_reader :fetch_options

    # @param klass [RIQObject] The child class that's being fetched, such as {Account} or {List}
    # @param opts [Hash] fetch options
    def initialize(klass, opts = {})
      @klass = klass
      begin
        raise unless @klass.ancestors.include? RIQ::RIQObject
      rescue
        raise RIQError, 'Must pass a RIQ Class'
      end
      @fetch_options = {}
      reset_cache
      
      # cause otherwise it's a variable
      self.send(:fetch_options=, opts)
      @client = RIQ.client
    end

    # Iterator for each item in the manager. Pass a block to it!
    # @example
    #   RIQ.lists.each do |l|
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
    # @return [RIQObject]
    def first
      reset_cache
      fetch_page.first
    end

    # Set fetch options
    # @param opts [Hash] Where values are either strings or arrays
    def fetch_options=(opts = {})
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
      # I believe this is resetting opts somehow/not respecting limit
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
      BatchManager.new(RIQ::List, opts)
    end

    # @macro conv
    def contacts(opts = {})
      BatchManager.new(RIQ::Contact, opts)
    end

    # @macro conv
    def accounts(opts = {})
      BatchManager.new(RIQ::Account, opts)
    end
  end
end
