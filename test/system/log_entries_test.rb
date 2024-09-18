require "application_system_test_case"

class LogEntriesTest < ApplicationSystemTestCase
  setup do
    @log_entry = log_entries(:one)
  end

  test "visiting the index" do
    visit log_entries_url
    assert_selector "h1", text: "Log entries"
  end

  test "should create log entry" do
    visit log_entries_url
    click_on "New log entry"

    fill_in "Data json", with: @log_entry.data_json
    fill_in "Data schema", with: @log_entry.data_schema
    fill_in "Data set", with: @log_entry.data_set_id
    fill_in "Timestamp", with: @log_entry.timestamp
    fill_in "Title", with: @log_entry.title
    click_on "Create Log entry"

    assert_text "Log entry was successfully created"
    click_on "Back"
  end

  test "should update Log entry" do
    visit log_entry_url(@log_entry)
    click_on "Edit this log entry", match: :first

    fill_in "Data json", with: @log_entry.data_json
    fill_in "Data schema", with: @log_entry.data_schema
    fill_in "Data set", with: @log_entry.data_set_id
    fill_in "Timestamp", with: @log_entry.timestamp
    fill_in "Title", with: @log_entry.title
    click_on "Update Log entry"

    assert_text "Log entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Log entry" do
    visit log_entry_url(@log_entry)
    click_on "Destroy this log entry", match: :first

    assert_text "Log entry was successfully destroyed"
  end
end
