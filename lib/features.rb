class Features
  extend Forwardable
  def_delegators :@features, :==

  def self.named
    [:html?, :quoted_printable?]
  end

  def initialize(message)
    @features = self.class.named.map { |feature| message.public_send(feature) ? 1.0 : 0.0 }
  end

  def to_example
    Libsvm::Node.features(@features)
  end
end
