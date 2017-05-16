require "rails_helper"

RSpec.describe LocalRelationship, type: :model do 

	before(:each) do
		@relazioneL=LocalRelationship.new(follower_id:1, followed_id:1)
		expect(@relazioneL).to_not eq(nil)
	end

	describe "test validates" do

		it "è valido" do
			expect(@relazioneL).to be_valid
		end

		it "follower_id nullo" do
			@relazioneL.follower_id=nil
			expect(@relazioneL).to_not be_valid
			@relazioneL.follower_id=""
			expect(@relazioneL).to_not be_valid
		end

		it "followed_id nullo" do
			@relazioneL.followed_id=nil
			expect(@relazioneL).to_not be_valid
			@relazioneL.followed_id=""
			expect(@relazioneL).to_not be_valid
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
			expect(associazione.options).to eq(class_name:"Local")
		end
	end
end
