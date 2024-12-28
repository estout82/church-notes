# frozen_string_literal: true

# Represents a user + organization relationship
class OrganizationMember < ApplicationRecord
  belongs_to :organization
  belongs_to :user
end
