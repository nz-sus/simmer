require "application_system_test_case"

class DataSetsTest < ApplicationSystemTestCase
  setup do
    @data_set = data_sets(:one)
  end

  test "visiting the index" do
    visit data_sets_url
    assert_selector "h1", text: "Data sets"
  end

  test "should create data set" do
    visit data_sets_url
    click_on "New data set"

    fill_in "Client", with: @data_set.client_id
    fill_in "Description", with: @data_set.description
    fill_in "Name", with: @data_set.name
    fill_in "Time range end", with: @data_set.time_range_end
    fill_in "Time range start", with: @data_set.time_range_start
    click_on "Create Data set"

    assert_text "Data set was successfully created"
    click_on "Back"
  end

  test "should update Data set" do
    visit data_set_url(@data_set)
    click_on "Edit this data set", match: :first

    fill_in "Client", with: @data_set.client_id
    fill_in "Description", with: @data_set.description
    fill_in "Name", with: @data_set.name
    fill_in "Time range end", with: @data_set.time_range_end
    fill_in "Time range start", with: @data_set.time_range_start
    click_on "Update Data set"

    assert_text "Data set was successfully updated"
    click_on "Back"
  end

  test "should destroy Data set" do
    visit data_set_url(@data_set)
    click_on "Destroy this data set", match: :first

    assert_text "Data set was successfully destroyed"
  end
end
