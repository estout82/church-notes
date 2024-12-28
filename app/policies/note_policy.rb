#
# Controls access to note records
#

class NotePolicy < ApplicationPolicy
  def can_view?
    editor_on_note_account?
  end

  def can_update?
    editor_on_note_account?
  end

  def can_manage?
    editor_on_note_account?
  end

  def can_destroy?
    editor_on_note_account?
  end

  def can_create?
    editor?
  end

  private

  def editor?
    @user.permissions.for_account? @account, :editor
  end

  def editor_on_note_account?
    @user.permissions.for_account?(@entity.account, :editor)
  end
end