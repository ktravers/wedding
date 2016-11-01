class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_one :plus_one

  validates_presence_of :user, :event
  validates_uniqueness_of :user_id, scope: [:event_id]
  validates :accepted_at, absence: true, if: :declined_at
  validates :declined_at, absence: true, if: :accepted_at

  scope :unsent,        -> { where(sent_at: nil) }
  scope :unconfirmed,   -> { where(accepted_at: nil, declined_at: nil) }
  scope :attending,     -> { where.not(accepted_at: nil) }
  scope :not_attending, -> { where.not(declined_at: nil) }

  def sent!
    update(sent_at: Time.now)
  end

  def accepted!
    update(accepted_at: Time.now)
  end

  def declined!
    update(declined_at: Time.now)
  end

  def attending?
    !!accepted_at
  end

  def not_attending?
    !!declined_at
  end

  def unconfirmed?
    accepted_at.nil? && declined_at.nil?
  end

  def confirmed_plus_one?
    return false unless plus_one
    plus_one.accepted_at || plus_one.declined_at
  end

  def unconfirmed_plus_one?
    return false unless plus_one
    plus_one.accepted_at.nil? && plus_one.declined_at.nil?
  end

  def status
    if accepted_at
      'attending'
    elsif declined_at
      'not attending'
    else
      'unconfirmed'
    end
  end
end
