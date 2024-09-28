require 'test_helper'
require 'rails_helper'

class LogEntriesControllerTest < ActionDispatch::IntegrationTest
  let(:user) { create(:user) }

  setup do
    sign_in user # Devise helper to simulate login
    @log_entry = log_entries(:one)
  end

  test 'should get index' do
    get log_entries_url
    assert_response :success
  end

  test 'should get new' do
    get new_log_entry_url
    assert_response :success
  end

  test 'should create log_entry' do
    assert_difference('LogEntry.count') do
      post log_entries_url,
           params: { log_entry: { data_json: @log_entry.data_json, data_schema: @log_entry.data_schema,
                                  data_set_id: @log_entry.data_set_id, timestamp: @log_entry.timestamp, title: @log_entry.title } }
    end

    assert_redirected_to log_entry_url(LogEntry.last)
  end

  test 'should show log_entry' do
    get log_entry_url(@log_entry)
    assert_response :success
  end

  test 'should get edit' do
    get edit_log_entry_url(@log_entry)
    assert_response :success
  end

  test 'should update log_entry' do
    patch log_entry_url(@log_entry),
          params: { log_entry: { data_json: @log_entry.data_json, data_schema: @log_entry.data_schema,
                                 data_set_id: @log_entry.data_set_id, timestamp: @log_entry.timestamp, title: @log_entry.title } }
    assert_redirected_to log_entry_url(@log_entry)
  end

  test 'should destroy log_entry' do
    assert_difference('LogEntry.count', -1) do
      delete log_entry_url(@log_entry)
    end

    assert_redirected_to log_entries_url
  end
end
