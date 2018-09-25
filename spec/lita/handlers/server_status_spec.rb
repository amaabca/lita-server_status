require 'spec_helper'
require 'timecop'

describe Lita::Handlers::ServerStatus, lita_handler: true do
  let(:formatted_local_time) { Time.now.strftime('%Y-%m-%d %H:%M') }

  before(:each) do
    allow_any_instance_of(Lita::Handlers::ServerStatus).to receive(:formatted_time).and_return(formatted_local_time)
  end

  context 'New HipChat messaging in place' do
    it { is_expected.to route(':eyes: Bobby Marley is deploying fakeapp/staging to red_team_rocks').to(:save_status) }
    it { is_expected.to route_command('server status').to(:list_statuses) }

    it 'saves the server status' do
      expect_any_instance_of(Lita::Handlers::ServerStatus).to receive(:save_status)
      send_message(%{:eyes: Bob Marley is deploying fakeapp/staging to red_team_rocks})
    end

    it 'update the server status if it changes' do
      Timecop.freeze(Time.now) do
        send_message(%{:eyes: Bob Marley is deploying fakeapp/staging to branchname_here})
        send_command('server status')
        expect(replies.last).to include("fakeapp branchname_here: staging (Bob Marley @ #{formatted_local_time})")

        send_message(%{:eyes: Bob Marley is deploying fakeapp/staging to new_branch})
        send_command('server status')
        expect(replies.last).to include("fakeapp new_branch: staging (Bob Marley @ #{formatted_local_time})")
      end
    end

    it 'should list the current server statuses' do
      Timecop.freeze(Time.now) do
        send_message(%{:eyes: Bobby Marley is deploying fakeapp/staging to red_team_rocks})
        send_command('server status')
        expect(replies.last).to include("fakeapp red_team_rocks: staging (Bobby Marley @ #{formatted_local_time})")

        send_message(%{:eyes: Bobby Marley is deploying fakeapp/production to red_team_rocks})
        send_command('server status')
        expect(replies.last).to include("fakeapp red_team_rocks: production (Bobby Marley @ #{formatted_local_time})")
      end
    end
  end

  it 'admits when there are no statuses' do
    send_command('server status')
    expect(replies.last).to eq('I don\'t know what state the servers are in.')
  end
end
