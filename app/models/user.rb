class User < ActiveRecord::Base
	has_secure_password
    
	has_many :temp_artists, dependent: :destroy
	has_many :user_temp_artists, dependent: :destroy
	has_many :temp_artists, through: :user_temp_artists


	before_save {self.email = email.downcase}
  validates :fname, presence: true, length: {minimum: 3, maximum: 40}
  validates :lname, presence: true, length: {minimum: 3, maximum: 40}
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true, 
                    uniqueness: {case_sensitive: false}, 
                    format: {with: VALID_EMAIL_REGEX}
    #NEED TO ADD EMAIL CONFIRMATION BY ACTION MAILER
    
    def table_name
		self.table_name
	end

end