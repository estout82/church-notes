# frozen_string_literal: true

# Sends purchases to slack (via make.com)
class Marketing::PostPurchaseJob < ApplicationJob
  def perform(sign_up:)
    res = HTTParty.post(
      "https://hook.us1.make.com/mxzk5nxb8aclrxvhwp01s3n2gcjy2m2f",
      body: {
        message: "#{sign_up.first_name} #{sign_up.last_name} (#{sign_up.email}) signed up for #{sign_up.plan}"
      }.to_json,
      headers: { "Content-Type": "application/json" }
    )

    raise if res.code >= 300
  end
end
