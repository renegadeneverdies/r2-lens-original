# frozen_string_literal: true

require "mongoid"

class Level
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: Integer
  field :exp, type: Integer

  index({ number: 1 }, { unique: true, background: true })

  validates :number, presence: true, uniqueness: true
  validates :exp, presence: true
end
