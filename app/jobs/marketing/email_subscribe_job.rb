# frozen_string_literal: true

# Sends email subscribers to slack (via make.com)
class Marketing::EmailSubscribeJob < ApplicationJob
  def perform(email:, context:)
    message = if context == "free_trial"
      "#{email} is a new free trialer"
    else
      "#{email} is a new early adopter"
    end

    res = HTTParty.post(
      "https://hook.us1.make.com/mxzk5nxb8aclrxvhwp01s3n2gcjy2m2f/",
      body: { message: }.to_json,
      headers: { "Content-Type": "application/json" }
    )

    raise if res.code >= 300
  end
end
