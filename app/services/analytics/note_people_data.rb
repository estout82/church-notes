# frozen_string_literal: true

# Calculates data for people list on analytics page
class Analytics::NotePeopleData
  include ActiveModel::Model

  attr_accessor :note

  def data
    interactions = Interaction
      .includes(user: { messages: [:messages, :context], sent_messages: :recipient })
      .where("(data ->> 'note_id')::integer = ?", @note.id)

    users = interactions.map(&:user).uniq

    results = users.map do |user|
      # get all interactions for this user
      view_interactions = interactions.filter do |interaction|
        interaction.user == user && interaction.type == "Interactions::NoteView"
      end

      email_interactions = interactions.filter do |interaction|
        interaction.user == user && interaction.type == "Interactions::NoteEmail"
      end

      download_interactions = interactions.filter do |interaction|
        interaction.user == user && interaction.type == "Interactions::NoteDownload"
      end

      comments = if user
        user.sent_messages.filter { |m| m.recipient == note }
      else
        []
      end

      actions = note.actions.map do |action|
        Analytics::NotePeopleData::Action.new(
          action:,
          sent: false,
          completed: false,
          user:
        )
      end

      Analytics::NotePeopleData::Person.new(
        user:,
        view_count: view_interactions.size,
        last_viewed: view_interactions.max_by(&:created_at).created_at,
        email_count: email_interactions.size,
        download_count: download_interactions.size,
        comment_count: comments.size,
        actions:
      )
    end

    results.sort_by(&:last_viewed).reverse
  end

  # Represents a person and their analytic data for this note
  class Person
    include ActiveModel::Model

    attr_accessor :user, :view_count, :email_count, :download_count, :comment_count, :last_viewed, :actions

    def anonymous?
      user.blank?
    end
  end

  # Represents the status of an action (follow up) for a user
  class Action
    include ActiveModel::Model

    attr_accessor :action, :sent, :completed, :user

    def sent?
      !user
        .messages
        .filter { |m| m.context == action }
        .empty?
    end

    def completed?
      !user
        .messages
        .filter { |m| m.context == action && m.messages.present? }
        .empty?
    end
  end
end
