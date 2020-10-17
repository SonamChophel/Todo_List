class User < ApplicationRecord
    has_secure_password
    validates :username, :password_digest, :email, presence: true
    validates :email, uniqueness: true
    has_many :lists

    def generate_password_token!
        token = generate_token
        self.reset_password_token = token
        self.reset_password_sent_at = Time.now.utc
        save!
        token
      end
    
      def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
      end
    
      def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
      end
    
      private
    
      def generate_token
        SecureRandom.hex(10)
      end
end
