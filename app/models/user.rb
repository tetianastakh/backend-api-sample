class User < ApplicationRecord
  # Extensions
  ###########################################################################
  include Roleable
  has_secure_password
  acts_as_paranoid
  audited

  # Constants
  ###########################################################################

  # Enums
  ###########################################################################

  # Relations
  ###########################################################################
  has_many :permissions, class_name: Account::Permission.name, through: :company_role
  has_one  :company_user, class_name: ::Account::CompanyUser.name
  has_one  :company, through: :company_user, class_name: ::Account::Company.name
  has_many :permissions, class_name: Account::Permission.name, through: :company_role
  belongs_to :company_role, optional: true, class_name: Account::Role.name, foreign_key: :role_id

  accepts_nested_attributes_for :company_user, allow_destroy: true

  # Hooks
  ###########################################################################
  before_save { |user| user.email = user.email.downcase }
  after_create :send_confirmation_email

  # Scopes
  ###########################################################################

  # Validations
  ###########################################################################
  validates :email,
            uniqueness: { case_sensitive: false },
            format:     { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  validates :password,
            allow_nil: true,
            length:    { minimum: 6 }

  validates :first_name,
            :last_name,
            presence:  true,
            allow_nil: false

  # Instance Methods
  ###########################################################################

  def name
    [first_name, last_name].join(', ')
  end

  def send_confirmation_email
    UserMailer.confirm_user(self).deliver unless self.confirmed?
  end
end
