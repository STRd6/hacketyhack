require_relative 'editor/commands'
require_relative 'editor/undo_redo'

module HH::Editor

  class CodeEditor
    include UndoRedo

    attr_reader :script, :name, :last_saved

    def initialize script
      @script = script[:script] || ""
      @name = script[:name] || "A New Program"
      reset_undo_redo
    end

    # TODO: handle/inserts are awkward but somehow necessary for undo/redo to
    # work, better figure out another way however
    def handle_text_insertion pos, text
      add_command InsertionCommand.new(pos, text)
    end

    def insert_text pos, text
      @script.insert(pos, text)
    end

    def handle_text_deletion pos, len
      text = @script[pos, len]
      return if text.empty? # happens if len == 0 or pos to big
      add_command DeletionCommand.new(pos, text)
    end

    def delete_text pos, len
      @script[pos, len] = "" # TODO use slice?
    end

    def save name
      @name = name
      HH.save_script(@name, @script)
      @last_saved = Time.now
    end

  end

end

