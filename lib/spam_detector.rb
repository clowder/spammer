require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

module SpamDetector
  def self.train
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new

    # Must finish Coursera ML class
    parameter.cache_size = 1 # in megabytes
    parameter.eps = 0.001
    parameter.c = 10

    messages = []
    messages += Dir['data/easy_ham/*'].map { |path| PreclassifiedMessage.new(0, Message.new(path)) }
    messages += Dir['data/spam/*'].map     { |path| PreclassifiedMessage.new(1, Message.new(path)) }

    labels   = messages.map(&:label)
    features = messages.map { |message| Features.new(message).to_example }

    problem.set_examples(labels, features)

    model = Libsvm::Model.train(problem, parameter)
    model.save(model_path)
  end

  def self.classify(message_path)
    model            = Libsvm::Model.load(model_path)
    message          = Message.new(message_path)
    message_features = Features.new(message).to_example

    if model.predict(message_features) > 0
      :spam
    else
      :ham
    end
  end

  private
  def self.model_path
    'data/spam_detector.model'
  end
end
