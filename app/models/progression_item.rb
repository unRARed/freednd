class ProgressionItem < ApplicationRecord
  belongs_to :progression

  belongs_to :spell, optional: true
  belongs_to :skill, optional: true
  belongs_to :saving_throw, optional: true
end
