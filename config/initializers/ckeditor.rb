CKEditor5::Rails.configure do
  language "en"
  menubar visible: false

  toolbar :undo, :redo, :|,
    :bold, :italic, :|,
    :removeFormat, :|,
    :numberedList, :bulletedList, :|,
    :outdent, :indent

  plugins :WordCount, :RemoveFormat

  editable_height 200
end
