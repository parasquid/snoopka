# Snoopka

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'snoopka'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snoopka

## Usage

Sample code:

    require 'snoopka'
    require 'logger'

    class Handler
      def initialize
        @logger = Logger.new(STDOUT)
      end
    
      def handle(messages)
        messages.each do |message|
          payload = eval(message.payload.to_s.gsub('null', '""').gsub(':', '=>'))
          @logger.info payload
        end
      end
    
      def to_proc
        ->(messages) { handle(messages) }
      end
    end
    
    # pass the custom behavior as a block
    namespace :kafka do
      desc 'Starts the kafka listener'
      task :listen, [:daemonized] => :environment  do |t, args|
        Process.daemon(true, true) if args.daemonized
        puts 'Starting the Kafka listener'

        listener = Snoopka::Listener.new host: "localhost", port: 9092

        handler = Handler.new
        listener.add_observer 'test', &handler

        loop do
          listener.consume
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
