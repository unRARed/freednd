class DnD::Spell < ApplicationRecord
  scope :by_level, -> { order(:level => :asc) }
  scope :by_name, -> { order(:name => :asc) }

  def formatted_name
    base_name = self.name
    base_name = self.name + ' (Ritual)' if self.is_ritual?
    return "Cantrip: #{base_name}" if self.level == 0
    "Lvl #{self.level}: #{base_name}"
  end

  def formatted_selection
    "#{self.formatted_name} (#{self.dnd_classes})"
  end
end
