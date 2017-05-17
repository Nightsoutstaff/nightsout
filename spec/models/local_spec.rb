require "rails_helper"

RSpec.describe Local, type: :model do 

	before(:each) do
		@locale=Local.new(user_id:1,name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil,
		 website: "www.ciao.it", telephone:"0679621388", iva: "30669946545", category:"Pub",
		 city:"Roma,RM")
		expect(@locale).to_not eq(nil)
		allow(@locale).to receive(:picture_size).and_return(@locale)
		allow(@locale).to receive(:check_IVA).and_return(@locale)
	end

	describe "test validates" do

		it "è valido" do
			expect(@locale).to be_valid
		end

		it "user_id nullo" do
			@locale.user_id=nil
			expect(@locale).to_not be_valid
			@locale.user_id=""
			expect(@locale).to_not be_valid
		end

		it "nome nullo" do
			@locale.name=nil
			expect(@locale).to_not be_valid
			@locale.name=""
			expect(@locale).to_not be_valid
		end

		it "address nullo" do
			@locale.address=nil
			expect(@locale).to_not be_valid
			@locale.address=""
			expect(@locale).to_not be_valid
		end

		it "descrizione nulla" do
			@locale.description=nil
			expect(@locale).to_not be_valid
			@locale.description=""
			expect(@locale).to_not be_valid
		end

		it "len descrizione nullo" do
			expect((@locale.description).length).to be <= 1400
		end

		it "telefono nullo" do
			@locale.telephone=nil
			expect(@locale).to_not be_valid
			@locale.telephone=""
			expect(@locale).to_not be_valid
		end

		it "len telefono nullo" do
			expect(@locale.telephone.to_s.length+1).to be_between(10,11).inclusive
		end

		it "iva nulla" do
			@locale.iva=nil
			expect(@locale).to_not be_valid
			@locale.iva=""
			expect(@locale).to_not be_valid
		end

		it "categoria nulla" do
			@locale.category=nil
			expect(@locale).to_not be_valid
			@locale.category=""
			expect(@locale).to_not be_valid
		end
	end

	describe "test associazioni" do

		it "user" do
			associazione=described_class.reflect_on_association(:user)
			expect(associazione.macro).to eq :belongs_to
		end

		it "events" do
			associazione=described_class.reflect_on_association(:events)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(dependent: :destroy)
		end

		it "passive_local_relationships" do 
			associazione=described_class.reflect_on_association(:passive_local_relationships)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(class_name:"LocalRelationship", foreign_key:"followed_id", dependent: :destroy)
		end

		it "followers" do
			associazione=described_class.reflect_on_association(:followers)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(through: :passive_local_relationships, source: :follower)
		end

		it "comments" do
			associazione=described_class.reflect_on_association(:comments)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(as: :commentable,dependent: :destroy)
		end
	end

	describe "private method" do

		describe "picture_size" do
			it "should be less than 5MB" do
				expect(@locale.picture.size).to be <= 5.megabytes
			end 
		end

		describe "check_IVA" do
			it "iva non valida" do
				expect(@locale.iva.to_s.length).to eq(11) 
			end
		end
	end

	describe "test method notification" do

		after(:each) do
			@notif=Notification.new(text:"nuova notifica", written_by:"frank", event_id:1, local_id:1, end:"", user_id:1)
			expect(@notif).to_not eq(nil)
		end

		describe "self.addFollowing..." do

			it "addFollowing.. non valido" do
				@relationL=LocalRelationship.new(follower_id:1, followed_id:1)
				expect(@relationL).to be_valid
			end
		end

		describe "self.deleteFollowingLocal" do

			it "deleteFollowingLocal non valido" do
				@relationL=LocalRelationship.new(follower_id:1, followed_id:1)
				expect(@relationL).to be_valid
			end
		end
	end

end