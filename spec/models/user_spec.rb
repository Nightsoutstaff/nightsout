require "rails_helper"

RSpec.describe User, type: :model do 

	describe "test associazioni" do

		it "locals" do 
			associazione=described_class.reflect_on_association(:locals)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(dependent: :destroy)
		end

		it "notifications" do
			associazione=described_class.reflect_on_association(:notifications)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(dependent: :destroy)
		end

		it "active_event_relationships" do 
			associazione=described_class.reflect_on_association(:active_event_relationships)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(class_name:"EventRelationship",foreign_key:"follower_id",dependent: :destroy)
		end

		it "active_local_relationships" do
			associazione=described_class.reflect_on_association(:active_local_relationships)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(class_name:"LocalRelationship",foreign_key:"follower_id",dependent: :destroy)
		end

		it "following_local" do
			associazione=described_class.reflect_on_association(:following_local)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(through: :active_local_relationships, source: :followed)
		end

		it "following_event" do
			associazione=described_class.reflect_on_association(:following_event)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(through: :active_event_relationships,source: :followed)
		end

		it "comments" do
			associazione=described_class.reflect_on_association(:comments)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(dependent: :destroy)
		end
	end
end