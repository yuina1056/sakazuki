# == Schema Information
#
# Table name: sakes
#
#  id               :bigint           not null, primary key
#  alcohol          :float
#  aminosando       :float
#  aroma_impression :text
#  aroma_value      :integer
#  awa              :string
#  bindume_date     :date
#  bottle_level     :integer          default("sealed")
#  brew_year        :date
#  color            :string
#  genryomai        :string
#  hiire            :integer          default("unknown")
#  kakemai          :string
#  kobo             :string
#  kura             :string
#  moto             :integer          default("unknown")
#  name             :string
#  nigori           :string
#  nihonshudo       :float
#  note             :text
#  price            :integer
#  roka             :string
#  sando            :float
#  season           :string
#  seimai_buai      :integer
#  shibori          :string
#  size             :integer
#  taste_impression :text
#  taste_value      :integer
#  todofuken        :string
#  tokutei_meisho   :integer          default("none")
#  warimizu         :integer          default("unknown")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe Sake, type: :model do
  describe "validates" do
    subject { sake.save }

    context "if name is missing" do
      let(:sake) { FactoryBot.build(:sake, name: "") }

      it { is_expected.to be_falsy }
    end

    context "if kura is nil" do
      let(:sake) { FactoryBot.build(:sake, kura: nil) }

      it { is_expected.to be_falsy }
    end
  end
end
