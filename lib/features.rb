class Features
  def self.named
    [:html?, :quoted_printable?, :references?]
  end

  def initialize(message)
    @message = message
  end

  def html?
    @message.html? ? 1.0 : 0.0
  end

  def quoted_printable?
    @message.quoted_printable? ? 1.0 : 0.0
  end

  def references?
    @message.references.empty? ? 0.0 : 1.0
  end

  def to_example
    Libsvm::Node.features(to_a)
  end

  private
  def to_a
    self.class.named.map { |feature| self.send(feature) }
  end
end
