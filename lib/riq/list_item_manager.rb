require_relative 'batch_manager'
require_relative 'list_item'

module RIQ
  # Special child for initializing list items, who need to include extra info.
  class ListItemManager < BatchManager
    def initialize(lid, opts = {})
      raise RIQError, 'List id can\'t be nil' if lid.nil?
      @list_id = lid
      super(RIQ::ListItem, opts)
    end
  end
end