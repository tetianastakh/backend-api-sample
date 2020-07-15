class AggregateBase < SimpleDelegator
  PRIVATE = :__private__

  def initialize(aggregate)
    aggregate = OpenStruct.new(aggregate) if aggregate.is_a?(Hash)
    super(aggregate)
  end

  def private
    self.send(PRIVATE)
  end

  def to_h
    super.except(PRIVATE)
  end

  def as_json(options = nil)
    to_h.as_json(options)
  end

  def to_json(options = nil)
    to_h.to_json(options)
  end
end
