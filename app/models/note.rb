class Note < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates :body, presence: true
end
