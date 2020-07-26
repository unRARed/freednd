require 'rails_helper'

RSpec.describe Campaign, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:party) }
    it { is_expected.to have_many(:progressions) }
    it { is_expected.to have_many(:characters) }
    it { is_expected.to have_many(:users).through(:characters) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_dimensions_of(:decoration).
        width_max(3000)
    end
    it do
      is_expected.to validate_dimensions_of(:decoration).
        height_max(3000)
    end
    it do
      is_expected.to validate_content_type_of(:decoration).
        allowing('image/png', 'image/jpg', 'image/jpeg')
    end
  end

  describe 'class methods' do; end

  context 'instance methods' do
    describe 'decoration_thumb' do
      it 'returns nil when decoration is not set' do
        expect(subject.decoration_thumb).to eq nil
      end

      it 'returns a variant of the decoration' do
        campaign = create :campaign
        campaign.decoration.attach fixture_file_upload(
          "#{Rails.root.to_s}/spec/support/small-image.png",
          'image/png'
        )
        campaign.save!
        expect(campaign.decoration_thumb.is_a?(
          ActiveStorage::Variant)
        ).to eq true
      end
    end
  end
end
