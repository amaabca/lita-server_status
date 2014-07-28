require "spec_helper"
require "timecop"

describe Lita::Handlers::ServerStatus, lita_handler: true do
  let(:formatted_local_time) { Time.now.strftime("%Y-%m-%d %H:%M") }

  before(:each) do
    allow_any_instance_of(Lita::Handlers::ServerStatus).to receive(:formatted_time).and_return(formatted_local_time)
  end

  it { routes("Waffle McRib is starting deploy of 'APPNAME' from branch 'MASTER' to PRODUCTION").to(:save_status) }
  it { routes_command("server status").to(:list_statuses) }

  it "saves the server status" do
    expect_any_instance_of(Lita::Handlers::ServerStatus).to receive(:save_status)
    send_message(%{Waffle McRib is starting deploy of 'APPNAME' from branch 'MASTER' to PRODUCTION})
  end

  it "update the server status if it changes" do
    Timecop.freeze(Time.now) do
      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'MASTER' to PRODUCTION})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: MASTER (Waffle McRib @ #{formatted_local_time})")

      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'WAFFLE' to PRODUCTION})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: WAFFLE (Waffle McRib @ #{formatted_local_time})")
    end
  end

  it "should list the current server statuses" do
    Timecop.freeze(Time.now) do
      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'MASTER' to PRODUCTION})
      send_message(%{Waffle McRib is starting deploy of 'BATMAN' from branch 'AWESOME' to STAGING})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: MASTER (Waffle McRib @ #{formatted_local_time})")
      expect(replies.last).to include("BATMAN STAGING: AWESOME (Waffle McRib @ #{formatted_local_time})")
    end
  end
end
