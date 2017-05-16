require "rails_helper"

RSpec.describe RatingCache, type: :model do 

	describe "test associazioni" do 

		it "cacheable" do
			associazione=described_class.reflect_on_association(:cacheable)
			expect(associazione.macro).to eq :belongs_to
			expect(associazione.options).to eq(polymorphic: true)
		end
	end
end