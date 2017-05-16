require "rails_helper"

RSpec.describe Notification, type: :model do 

	before(:each) do
		@notifica=Notification.new(text:"nuova notifica", written_by:"frank", event_id:1, local_id:1, end:"", user_id:1)
		expect(@notifica).to_not eq(nil)
	end

	describe "test validates" do

		it "è valido" do
			expect(@notifica).to be_valid
		end

		it "user_id nullo" do
			@notifica.user_id=nil
			expect(@notifica).to_not be_valid
			@notifica.user_id=""
			expect(@notifica).to_not be_valid
		end

		it "text nullo" do
			@notifica.text=nil
			expect(@notifica).to_not be_valid
			@notifica.text=""
			expect(@notifica).to_not be_valid
		end

		it "len text nullo" do
			expect((@notifica.text).length).to be <= 1900
		end
	end

	describe "test associazioni" do

		it "user" do
			associazione=described_class.reflect_on_association(:user)
			expect(associazione.macro).to eq :belongs_to
		end

		it "event" do
			associazione=described_class.reflect_on_association(:event)
			expect(associazione.macro).to eq :belongs_to
		end

		it "local" do
			associazione=described_class.reflect_on_association(:local)
			expect(associazione.macro).to eq :belongs_to
		end

		it "comment" do
			associazione=described_class.reflect_on_association(:comment)
			expect(associazione.macro).to eq :belongs_to
		end
	end
end