#
# Query object used to get all the notes for a given account including shared notes
# NOTE: sub account sharing only goes one level for now
#

class NoteDecider
  def initialize(account:)
    @account = account
  end

  def run
    # all org wide notes
    org_notes = Note
      .where(account_id: @account.organization.accounts.ids)
      .where(sharing: :organization_sharing)

    # all accounts shared to sub_accounts from main account
    main_notes = Note
    .where(account_id: @account.main_account.id)
    .where(sharing: :sub_account_sharing)

    # all parent account notes
    parent_notes = Note
      .where(account_id: @account.parent_account_id)
      .where(sharing: :sub_account_sharing)

    Note
      .where(account_id: @account.id)
      .or(org_notes)
      .or(main_notes)
      .or(parent_notes)
  end
end
