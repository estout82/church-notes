class UserAccountMemberPresenter
  def initialize(member)
    @member = member
  end

  def eligible_accounts
    @member
      .user
      .default_organization
      .accounts
      .reject { |account| @member.user.accounts.include? account }
  end

  def eligible_roles
    [
      Role.new(name: :editor, display_name: "Editor"),
      Role.new(name: :scheduling, display_name: "Scheduling"),
      Role.new(name: :billing, display_name: "Billing"),
      Role.new(name: :admin, display_name: "Admin"),
      Role.new(name: :owner, display_name: "Owner")
    ]
  end

  class Role
    attr_accessor :name, :display_name

    def initialize(name:, display_name:)
      @name = name
      @display_name = display_name
    end
  end
end
