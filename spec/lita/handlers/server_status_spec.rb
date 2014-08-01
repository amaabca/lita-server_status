require "spec_helper"
require "timecop"

describe Lita::Handlers::ServerStatus, lita_handler: true do
  it { routes("Waffle McRib is starting deploy of 'APPNAME' from branch 'MASTER' to PRODUCTION").to(:save_status) }
  it { routes_command("server status").to(:list_statuses) }

  it "saves the server status" do
    expect_any_instance_of(Lita::Handlers::ServerStatus).to receive(:save_status)
    send_message(%{Waffle McRib is starting deploy of 'APPNAME' from branch 'MASTER' to PRODUCTION})
  end

  it "update the server status if it changes" do
    Timecop.freeze do
      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'MASTER' to PRODUCTION})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: MASTER (Waffle McRib @ #{Time.now.to_s})")

      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'WAFFLE' to PRODUCTION})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: WAFFLE (Waffle McRib @ #{Time.now.to_s})")
    end
  end

  it "should list the current server statuses" do
    Timecop.freeze do
      send_message(%{Waffle McRib is starting deploy of 'FAKEAPP' from branch 'MASTER' to PRODUCTION})
      send_message(%{Waffle McRib is starting deploy of 'BATMAN' from branch 'AWESOME' to STAGING})
      send_command("server status")
      expect(replies.last).to include("FAKEAPP PRODUCTION: MASTER (Waffle McRib @ #{Time.now.to_s})")
      expect(replies.last).to include("BATMAN STAGING: AWESOME (Waffle McRib @ #{Time.now.to_s})")
    end
  end

  it "admits when there are no statuses" do
    send_command("server status")
    expect(replies.last).to eq("I don't know what state the servers are in.")
  end
end
