require_relative 'batch_manager'
require_relative 'list_item'

module SIQ
  # Special child for initializing list items, who need to include extra info.
  class ListItemManager < BatchManager
    def initialize(lid, opts = {})
      raise SIQError, 'List id can\'t be nil' if lid.nil?
      @list_id = lid
      super(SIQ::ListItem, opts)
    end
  end
end