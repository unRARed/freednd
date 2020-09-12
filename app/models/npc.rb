class NPC < ApplicationRecord
  belongs_to :campaign

  validates :name, :location,
    presence: true

  has_one_attached :avatar

  has_rich_text :profile
  has_rich_text :notes

  def gender
    return 'Male' if is_male?
    'Female'
  end

  def avatar_thumb
    return nil unless avatar.attached?
    avatar.variant(
      auto_orient: true,
      combine_options: {
        resize: '120x120^', gravity: 'center', extent: '120x120'
      }
    ).processed
  end
end
