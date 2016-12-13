require "spec_helper"
require "timecop"

describe Lita::Handlers::ServerStatus, lita_handler: true do
  let(:formatted_local_time) { Time.now.strftime("%Y-%m-%d %H:%M") }

  before(:each) do
    allow_any_instance_of(Lita::Handlers::ServerStatus).to receive(:formatted_time).and_return(formatted_local_time)
  end

  context "New HipChat messaging in place" do
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
  end

  context "Old HipCHat messaging still has been used in some apps" do
    it { is_expected.to route("Waffle McRib is starting deploy of 'APPNAME' from branch 'MASTER' to PRODUCTION").to(:old_save_status) }
    it { is_expected.to route_command("server status").to(:list_statuses) }

    it "saves the server status" do
      expect_any_instance_of(Lita::Handlers::ServerStatus).to receive(:old_save_status)
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

  it "admits when there are no statuses" do
    send_command("server status")
    expect(replies.last).to eq("I don't know what state the servers are in.")
  end
end
