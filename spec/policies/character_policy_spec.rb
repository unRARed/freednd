require 'rails_helper'

RSpec.describe CharacterPolicy do
  subject { described_class.new(user, character) }

  let(:actions) { [:show, :create, :new, :update, :edit, :destroy] }

  context "for a visitor" do
    let(:user) { nil }
    let(:character) { create :character }

    it { is_expected.to forbid_actions(actions) }
  end

  context "for associated user" do
    let(:user) { create :user }
    let(:character) { create :character, user: user }

    it { is_expected.to permit_actions(actions) }
  end

  context "for non-associated user" do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:character) { create :character, user: other_user }

    it do
      is_expected.to forbid_actions(
        [:show, :update, :edit, :destroy]
      )
    end
  end

  context "for the dungeon master" do
    before(:each) do
      # dm creates campaign
      @user = create :user
      campaign = create :campaign, user: @user
      party = create :party, campaign: campaign

      # that another player joins
      party_member = create :user
      @character = create :character, user: party_member
      other_progression = create :progression,
        party: party,
        character: @character
    end

    subject { described_class.new(@user, @character) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions( [:update, :edit, :destroy]) }
  end

  context "for party member" do
    before(:each) do
      # dm creates campaign
      dm = create :user
      campaign = create :campaign, user: dm
      party = create :party, campaign: campaign

      # that another player joins
      other_user = create :user
      @character = create :character, user: other_user
      other_progression = create :progression,
        party: party,
        character: @character

      # and we also join it
      @user = create :user
      my_character = create :character, user: @user
      progression = create :progression,
        party: party,
        character: my_character
    end

    subject { described_class.new(@user, @character) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions( [:update, :edit, :destroy]) }
  end

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
