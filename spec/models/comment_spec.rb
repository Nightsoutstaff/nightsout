require 'rails_helper'

RSpec.describe Comment, type: :model do 
	
	before(:each) do
		@commento=Comment.new(commentable_type:"Local",content:"miafrase")
		expect(@commento).to_not eq(nil)
	end

	describe "test validates" do
		
		it "è valido" do
			expect(@commento).to be_valid
		end


		it "commentable_type local/event" do
			@commento.commentable_type="Local"
			expect(@commento).to be_valid
			@commento.commentable_type="Event"
			expect(@commento).to be_valid
		end

		it "contenuto nullo" do
			@commento.content=nil
			expect(@commento).to_not be_valid
			@commento.content=""
			expect(@commento).to_not be_valid
		end

		it "len contenuto" do
			expect((@commento.content).length).to be <= 400
		end
	end


	describe "test associazioni" do

		it "user_id" do
			associazione=described_class.reflect_on_association(:user)
			expect(associazione.macro).to eq :belongs_to
		end

		it "commentable" do
			associazione=described_class.reflect_on_association(:commentable)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(polymorphic: true)
		end

		it "parent_id" do
			associazione=described_class.reflect_on_association(:parent)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(class_name:"Comment",optional: true)
		end

		it "reply" do
			associazione=described_class.reflect_on_association(:replies)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(class_name:"Comment",foreign_key: :parent_id, dependent: :destroy)
		end
	end
end