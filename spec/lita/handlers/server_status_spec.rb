require "spec_helper"
require "timecop"

describe Lita::Handlers::ServerStatus, lita_handler: true do
  let(:formatted_local_time) { Time.now.strftime("%Y-%m-%d %H:%M") }

  before(:each) do
    allow_any_instance_of(Lita::Handlers::ServerStatus).to receive(:formatted_time).and_return(formatted_local_time)
  end
  it { is_expected.to route("Waffle McRib is deploying fakeapp/master to staging (production).").to(:save_status) }
  it { is_expected.to route_command("server status").to(:list_statuses) }

  it "saves the server status" do
    expect_any_instance_of(Lita::Handlers::ServerStatus).to receive(:save_status)
    send_message(%{Waffle McRib is deploying fakeapp/master to staging (production)})
  end

  it "update the server status if it changes" do
    Timecop.freeze(Time.now) do
      send_message(%{Waffle McRib is deploying fakeapp/master to staging (production)})
      send_command("server status")
      expect(replies.last).to include("fakeapp staging: master (Waffle McRib @ #{formatted_local_time})")

      send_message(%{Waffle McRib is deploying fakeapp/waffle to production (production)})
      send_command("server status")
      expect(replies.last).to include("fakeapp production: waffle (Waffle McRib @ #{formatted_local_time})")
    end
  end

  it "should list the current server statuses" do
    Timecop.freeze(Time.now) do
      send_message(%{Waffle McRib is deploying fakeapp/master to production (production)})
      send_message(%{Waffle McRib is deploying batman/awesome to staging (production)})
      send_command("server status")
      expect(replies.last).to include("fakeapp production: master (Waffle McRib @ #{formatted_local_time})")
      expect(replies.last).to include("batman staging: awesome (Waffle McRib @ #{formatted_local_time})")
    end
  end

  it "admits when there are no statuses" do
    send_command("server status")
    expect(replies.last).to eq("I don't know what state the servers are in.")
  end
end
