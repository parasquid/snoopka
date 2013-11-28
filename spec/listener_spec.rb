require 'spec_helper'
require 'snoopka/listener'

describe Snoopka::Listener do
  let(:settings_hash) { {host: "127.0.0.1", port: 9092} }
  let(:listener)      { Snoopka::Listener.new settings_hash }

  it 'retains the hash of settings' do
    expect(listener.settings).to eq settings_hash
  end

  it 'exposes the list of observers' do
    expect(listener.observers).to_not eq nil
  end

  it 'adds an observer to the listener' do
    listener.add_observer 'awesomecommerce' do |message|
      puts message.inspect
    end
    expect(listener.observer_count).to eq 1
  end

  context 'consumer' do

    let(:mocked_socket) { double(TCPSocket) }
    before :each do
      TCPSocket.stub(:new).and_return(mocked_socket) # don't use a real socket
    end

    it 'creates a consumer given a topic and settings' do
      consumer = listener.create_consumer('awesomecommerce')
      expect(consumer).to_not be_nil
    end

    it 'peforms the block when a message is received in the subscribed topic' do
      bytes = [0].pack("n") + [1].pack('N') + [21346].pack('q').reverse # it's magic!!
      allow(mocked_socket).to receive(:read).and_return(bytes)
      allow(mocked_socket).to receive(:write)

      @test = 0
      listener.add_observer 'awesomecommerce' do |message|
        @test += 1
      end

      listener.consume
      expect(@test).to eq 1
    end
  end
end