require_relative '../lib/hypesets'

describe Hypesets::Client do
  let(:hostname) { 'hypesets.org' }
  let(:port) { 30303 }
  let(:socket) { double }

  let(:client) { Hypesets::Client.new(hostname, port) }

  before do
    allow(TCPSocket).to receive(:new).with(hostname, port).and_return socket
  end

  it "adds new set" do
    expect(socket).to receive(:puts).with("ADD set1 element1")
    expect(socket).to receive(:gets).and_return("DONE\n")

    status = client.add "set1", "element1"
    expect(status).to eql(:ok)
  end

  it "estimates" do
    expect(socket).to receive(:puts).with("ESTIMATE A Z")
    expect(socket).to receive(:gets).exactly(2).times.and_return("A,32", "\nB,21\nDONE\n")

    result = client.estimate("A", "Z")

    expect(result).to be == [Hypesets::Estimation.new("A", 32), Hypesets::Estimation.new("B", 21)]
  end
end
