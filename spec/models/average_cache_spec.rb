require 'rails_helper'

RSpec.describe AverageCache, type: :model do
	
	describe "test associazioni" do
		
		it "rater" do
			associazione=described_class.reflect_on_association(:rater)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(class_name:"User")
		end

		it "rateable" do
			associazione=described_class.reflect_on_association(:rateable)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(polymorphic: true)
		end
	end
end