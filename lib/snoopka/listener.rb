require 'kafka'

module Snoopka
  class Listener

    def initialize(settings = {})
      @settings = settings
      @observers = {}
      @consumers = []
    end

    def settings
      @settings
    end

    def observers
      @observers
    end

    def observer_count
      @observers.count
    end

    def add_observer(topic = '', &proc)
      @observers[topic] ||= []
      @observers[topic] << proc
      @consumers << create_consumer(topic)
    end

    # loop through all observers of this topic and call the associated blocks
    def notify_observers(topic, messages)
      @observers[topic].each do |observer|
        observer.call messages
      end
    end

    # loop through all consumers to read from kafka
    def consume
      @consumers.each do |consumer|
        messages = consumer.consume
        notify_observers(consumer.topic, messages) if messages.length > 0
      end
    end

    # create a kafka consumer for the topic
    def create_consumer(topic)
      Kafka::Consumer.new(
        {
          host: @settings[:host] || 'localhost',
          port: @settings[:port] || 9092,
          topic: topic
        }
      )
    end

  end
end