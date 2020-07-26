require 'rails_helper'

RSpec.describe Character, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:progressions) }
    it { is_expected.to have_many(:parties).through(:progressions) }
    it { is_expected.to have_many(:campaigns).through(:parties) }
    it { is_expected.to have_many(:party_members).through(:parties) }
  end

  describe 'validations' do
    context 'scope' do
      before { FactoryBot.create(:character) }
      it do
        is_expected.to validate_uniqueness_of(:name).
          scoped_to(:user_id).
          with_message 'was already used for another character you have.'
      end
    end
    it { is_expected.to validate_presence_of(:alignment) }
    it { is_expected.to validate_presence_of(:dnd_class) }
    it { is_expected.to validate_presence_of(:race) }
    it { is_expected.to validate_presence_of(:background) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_dimensions_of(:avatar).width_max(3000) }
    it { is_expected.to validate_dimensions_of(:avatar).height_max(3000) }
    it do
      is_expected.to validate_content_type_of(:avatar).
        allowing('image/png', 'image/jpg', 'image/jpeg')
    end
  end

  describe 'class methods' do; end

  context 'instance methods' do
    describe 'base_speed' do
      it 'is 25 for 3 specific races' do
        ['Dwarf', 'Halfling', 'Gnome'].each do |race|
          subject.race = race
          expect(subject.base_speed).to eq 25
        end
      end

      it 'is 30 otherwise' do
        (
          Character.races.keys - ['Dwarf', 'Halfling', 'Gnome']
        ).each do |race|
          subject.race = race
          expect(subject.base_speed).to eq 30
        end
      end
    end

    describe 'avatar_portrait' do
      it 'returns nil when avatar is not set' do
        expect(subject.avatar_portrait).to eq nil
      end

      it 'returns a variant of the avatar' do
        character = create :character
        character.avatar.attach fixture_file_upload(
          "#{Rails.root.to_s}/spec/support/small-image.png",
          'image/png'
        )
        character.save!
        expect(character.avatar_portrait.is_a?(
          ActiveStorage::Variant)
        ).to eq true
      end
    end

    describe 'avatar_portrait' do
      it 'returns nil when avatar is not set' do
        expect(subject.avatar_thumb).to eq nil
      end

      it 'returns a variant of the avatar' do
        character = create :character
        character.avatar.attach fixture_file_upload(
          "#{Rails.root.to_s}/spec/support/small-image.png",
          'image/png'
        )
        character.save!
        expect(character.avatar_thumb.is_a?(
          ActiveStorage::Variant)
        ).to eq true
      end
    end
  end
end
