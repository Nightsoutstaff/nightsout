require "rails_helper"

RSpec.describe EventRelationship, type: :model do 

	before(:each) do
		@relazioneE=EventRelationship.new(follower_id:1,followed_id: 1)
		expect(@relazioneE).to_not eq(nil)
	end

	describe "test validates" do

		it "è valido" do
			expect(@relazioneE).to be_valid
		end

		it "follower_id" do
			@relazioneE.follower_id=nil
			expect(@relazioneE).to_not be_valid
			@relazioneE.follower_id=""
			expect(@relazioneE).to_not be_valid
		end

		it "followed_id" do
			@relazioneE.followed_id=nil
			expect(@relazioneE).to_not be_valid
			@relazioneE.followed_id=""
			expect(@relazioneE).to_not be_valid
		end

	end

	describe "test associazioni" do

		it "follower" do
			associazione=described_class.reflect_on_association(:follower)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(class_name:"User")
		end

		it "followed" do
			associazione=described_class.reflect_on_association(:followed)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(class_name:"Event")
		end
	end
end