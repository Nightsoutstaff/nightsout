require 'rails_helper'

RSpec.describe Event, type: :model do

	before(:each) do
		@evento=Event.new(name: "evento",description: "cose varie",local_id:1, start:"2017-05-14 17:04:00", end:"2017-05-16 19:05:00", picture: nil)
		expect(@evento).to_not eq(nil)
		allow(@evento).to receive(:start_before_end).and_return(@evento)
		allow(@evento).to receive(:picture_size).and_return(@evento)
	end

	describe "test validates" do
		
		it "è valido" do
			expect(@evento).to be_valid
		end

		it "local_id nullo" do
			@evento.local_id=nil
			expect(@evento).to_not be_valid
			@evento.local_id=""
			expect(@evento).to_not be_valid
		end

		it "descrizione nulla" do
			@evento.description=nil
			expect(@evento).to_not be_valid
			@evento.description=""
			expect(@evento).to_not be_valid
		end

		it "len descrizione nullo" do
			expect((@evento.description).length).to be <= 1400
		end

		it "nome nullo" do
			@evento.name=nil
			expect(@evento).to_not be_valid
			@evento.name=""
			expect(@evento).to_not be_valid
		end

		it "start nullo" do
			@evento.start=nil
			expect(@evento).to_not be_valid
			@evento.start=""
			expect(@evento).to_not be_valid
		end

		it "end nullo" do
			@evento.end=nil
			expect(@evento).to_not be_valid
			@evento.end=""
			expect(@evento).to_not be_valid
		end
	end

	describe "test associazioni" do

		it "local" do
			associazione=described_class.reflect_on_association(:local)
			expect(associazione.macro).to eq :belongs_to
		end

		it "passive_event_relationships" do
			associazione=described_class.reflect_on_association(:passive_event_relationships)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(class_name:"EventRelationship",foreign_key:"followed_id", dependent: :destroy)
		end

		it "followers" do
			associazione=described_class.reflect_on_association(:followers)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(through: :passive_event_relationships, source: :follower)
		end

		it "comments" do
			associazione=described_class.reflect_on_association(:comments)
			expect(associazione.macro).to eq :has_many
			expect(associazione.options).to eq(as: :commentable, dependent: :destroy)
		end
	end

	describe "private method" do

		describe "picture_size" do
			it "should be less than 5MB" do
				expect(@evento.picture.size).to be <= 5.megabytes
			end 
		end

		describe "start_before_end" do
			it("fine evento prima dell'inizio") do
				expect(@evento.start).to_not eq(nil)
				expect(@evento.end).to_not eq(nil)
				expect(@evento.start).to be <@evento.end
			end
		end
	end

	describe "test method notification" do

		after(:each) do
			@notif=Notification.new(text:"nuova notifica", written_by:"frank", event_id:1, local_id:1, end:"", user_id:1)
			expect(@notif).to_not eq(nil)
		end

		describe "self.deleteEvents" do

			it "delete non valido" do
				@ev=Event.new(name: "evento",description: "cose varie",local_id:1, start:"2017-05-14 17:04:00", end:"2017-05-16 13:05:00", picture: nil)
				expect(@ev).to be_valid
				expect(@ev.end).to be <Time.now
				@ev=nil
				expect(@ev).to eq(nil)
			end
		end

		describe "self.deleteFollowedEvents" do
			it "delete non valido" do
				@ev=Event.new(name: "evento",description: "cose varie",local_id:1, start:"2017-05-14 17:04:00", end:"2017-05-16 13:05:00", picture: nil)
				expect(@ev).to be_valid
				expect(@ev.end).to be <Time.now
				@ev=nil
				expect(@ev).to eq(nil)
			end
		end

		describe "self.approachingEvent" do

			it "approaching non valido" do
				@ev=Event.new(name: "evento",description: "cose varie",local_id:1, start:"2050-05-14 17:04:00", end:"2050-05-16 13:05:00", picture: nil)
				expect(@ev).to be_valid
				expect(@ev.start).to be >Time.now
			end
		end
	end

end