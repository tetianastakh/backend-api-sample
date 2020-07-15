class BaseRepository
  class << self
    def order(entities, options)
      entities.order(options[:field] => options[:direction])
    end

    def paginate(entities, options)
      return entities if options[:per_page] == 'ALL'

      entities.paginate(options.slice(:page, :per_page))
    end

    def format_date(date)
      return date if date.is_a?(Date)
      return Date.parse(date)
    rescue ArgumentError => e
      raise ::Exceptions::ArgumentError.new(message: "Invalid date: '#{date}'")
    end
  end
end
