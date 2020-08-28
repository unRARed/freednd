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

    describe 'passive_check' do
      it 'has a base value of 10' do
        expect(subject.passive_check('Perception')).to eq 10
      end

      it 'adds the wisdom modifier' do
        subject.skills.build name: 'Perception',
          value: 1
        expect(subject.passive_check('Perception')).to eq 11
      end

      it 'adds the proficiency bonus conditionally' do
        subject.skills.build name: 'Perception',
          is_proficient: true,
          value: 0
        subject.experience = 6500 # proficiency bonus 3
        expect(subject.passive_check('Perception')).to eq 13
      end
    end

    describe 'wallet' do
      it 'converts copper_pieces to hash of denominations' do
        subject.update copper_pieces: 98765

        expect(subject.wallet[:platinum]).to eq 98
        expect(subject.wallet[:gold]).to eq 7
        expect(subject.wallet[:electrum]).to eq 1
        expect(subject.wallet[:silver]).to eq 1
        expect(subject.wallet[:copper]).to eq 5
      end

      it 'returns 0 for a demoninations not exceeded' do
        subject.update copper_pieces: 1

        expect(subject.wallet[:platinum]).to eq 0
        expect(subject.wallet[:gold]).to eq 0
        expect(subject.wallet[:electrum]).to eq 0
        expect(subject.wallet[:silver]).to eq 0
      end

      it 'handles nil value' do
        expect(subject.wallet[:copper]).to eq 0
      end
    end
  end

  context 'private instance methods' do
    describe 'calculate_ability_mod' do
      it 'is based on the ability value' do
        expect(subject.send('calculate_ability_mod', 26)).to eq 8
        expect(subject.send('calculate_ability_mod', 15)).to eq 2
        expect(subject.send('calculate_ability_mod', 10)).to eq 0
        expect(subject.send('calculate_ability_mod', 6)).to eq -2
        expect(subject.send('calculate_ability_mod', 5)).to eq -3
        expect(subject.send('calculate_ability_mod', 4)).to eq -3
        expect(subject.send('calculate_ability_mod', 1)).to eq -5
      end
    end
  end
end
