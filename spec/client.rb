require 'spec_helper'

module PjLink
  describe Client do
    context 'a port is provided' do
      it 'accepts ADDRESS:PORT notation' do
        client = Client.new('0.0.0.0:1000')

        expect(client.gateway.port).to eq 1000
      end
    end

    context 'no port is provided' do
      describe Client::Gateway do
        it 'assigns a default port when no port is given' do
          gateway = Client::Gateway.new '0.0.0.0'

          expect(gateway.port).
            to eq Client::Gateway::DEFAULT_PORT
        end
      end
    end
  end

end
