require 'rails_helper'

RSpec.describe Progression, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:character) }
    it { is_expected.to belong_to(:party) }
  end

  describe 'validations' do
    before { FactoryBot.create(:progression) }
    it do
      is_expected.to validate_uniqueness_of(:character_id).
        scoped_to(:party_id).
        with_message('may only exist once in the Party.')
    end
  end

  describe 'class methods' do; end

  context 'instance methods' do
    describe 'level' do
      it 'is overridden by the explicit_level value' do
        subject.explicit_level = 1
        expect(subject.level).to eq subject.explicit_level
      end

      it 'is based on the experience value' do
        subject.experience = 299
        expect(subject.level).to eq 1
        subject.experience = 300
        expect(subject.level).to eq 2
        subject.experience = 48000
        expect(subject.level).to eq 9
        subject.experience = 305000
        expect(subject.level).to eq 19
        subject.experience = 999999
        expect(subject.level).to eq 20
      end
    end

    describe 'proficiency_bonus' do
      it 'is based on the level value' do
        subject.experience = 6500 # level 5
        expect(subject.proficiency_bonus).to eq 3
        subject.explicit_level = 17
        expect(subject.proficiency_bonus).to eq 6
      end
    end

    describe 'passive_wisdom' do
      it 'has a base value of 10' do
        expect(subject.passive_wisdom).to eq 10
      end

      it 'adds the wisdom modifier' do
        subject.wisdom = 12
        expect(subject.passive_wisdom).to eq 11
      end

      it 'adds the proficiency bonus conditionally' do
        subject.skills.build name: 'Perception',
          is_proficient: true,
          value: 0
        subject.experience = 6500 # proficiency bonus 3
        expect(subject.passive_wisdom).to eq 13
      end
    end
  end
end
