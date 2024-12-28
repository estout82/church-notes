# frozen_string_literal: true

# Represents a new sign up for the app
class SignUp < ApplicationRecord
  belongs_to :organization, foreign_key: true, optional: true
  belongs_to :subscription, foreign_key: true, optional: true

  enum plan: { no_plan: 0, base: 1, pro: 2, multisite: 3 }

  validates :first_name, :last_name, :email, :plan, presence: true

  before_create { self.alt_id = SecureRandom.alphanumeric(24).downcase }

  def stripe_price_id
    case plan
    when "base"
      Rails.env.production? ? "price_1OhOSaFyoYdoRub6j8GqjyWy" : "price_1OhOHeFyoYdoRub6Sw0Nl1yN"
    when "pro"
      Rails.env.production? ? "price_1OhOQtFyoYdoRub60GoSM1ZL" : "price_1OhOHsFyoYdoRub66qPzcw7m"
    when "multisite"
      Rails.env.production? ? "price_1OhORRFyoYdoRub6LiG8AyCv" : "price_1OhOI5FyoYdoRub6nGfsiyAX"
    end
  end

  def to_param
    alt_id
  end
end
