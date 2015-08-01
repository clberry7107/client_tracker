class User < ActiveRecord::Base
	has_secure_password

	before_save {self.email = email.downcase}
  validates :fname, presence: true, length: {minimum: 3, maximum: 40}
  validates :lname, presence: true, length: {minimum: 3, maximum: 40}
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true, 
                    uniqueness: {case_sensitive: false}, 
                    format: {with: VALID_EMAIL_REGEX}


end