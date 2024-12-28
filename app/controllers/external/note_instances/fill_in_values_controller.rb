# frozen_string_literal: true

# Sets fill in values for external notes when people are logged in
class External::NoteInstances::FillInValuesController < External::BaseController
  before_action :require_external_login!
  before_action :set_note_instance!

  def update
    values = @instance.fill_in_values
    values[params[:index]] = fill_in_value_params[:value]

    @instance.update! fill_in_values: values
  end

  private

  def set_note_instance!
    @instance = NoteInstance.find params[:note_instance_id]
  end

  def fill_in_value_params
    params
      .require(:fill_in_value)
      .permit(:value)
  end
end
