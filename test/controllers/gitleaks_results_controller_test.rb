require "test_helper"

class GitleaksResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gitleaks_result = gitleaks_results(:one)
  end

  test "should get index" do
    get gitleaks_results_url
    assert_response :success
  end

  test "should get new" do
    get new_gitleaks_result_url
    assert_response :success
  end

  test "should create gitleaks_result" do
    assert_difference("GitleaksResult.count") do
      post gitleaks_results_url, params: { gitleaks_result: { author: @gitleaks_result.author, commit: @gitleaks_result.commit, date: @gitleaks_result.date, description: @gitleaks_result.description, email: @gitleaks_result.email, end_column: @gitleaks_result.end_column, end_line: @gitleaks_result.end_line, entropy: @gitleaks_result.entropy, file: @gitleaks_result.file, fingerprint: @gitleaks_result.fingerprint, log_entry_id: @gitleaks_result.log_entry_id, match: @gitleaks_result.match, message: @gitleaks_result.message, rule_id: @gitleaks_result.rule_id, secret: @gitleaks_result.secret, start_column: @gitleaks_result.start_column, start_line: @gitleaks_result.start_line, symlink_file: @gitleaks_result.symlink_file, gltags: @gitleaks_result.gltags } }
    end

    assert_redirected_to gitleaks_result_url(GitleaksResult.last)
  end

  test "should show gitleaks_result" do
    get gitleaks_result_url(@gitleaks_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_gitleaks_result_url(@gitleaks_result)
    assert_response :success
  end

  test "should update gitleaks_result" do
    patch gitleaks_result_url(@gitleaks_result), params: { gitleaks_result: { author: @gitleaks_result.author, commit: @gitleaks_result.commit, date: @gitleaks_result.date, description: @gitleaks_result.description, email: @gitleaks_result.email, end_column: @gitleaks_result.end_column, end_line: @gitleaks_result.end_line, entropy: @gitleaks_result.entropy, file: @gitleaks_result.file, fingerprint: @gitleaks_result.fingerprint, log_entry_id: @gitleaks_result.log_entry_id, match: @gitleaks_result.match, message: @gitleaks_result.message, rule_id: @gitleaks_result.rule_id, secret: @gitleaks_result.secret, start_column: @gitleaks_result.start_column, start_line: @gitleaks_result.start_line, symlink_file: @gitleaks_result.symlink_file, gltags: @gitleaks_result.gltags } }
    assert_redirected_to gitleaks_result_url(@gitleaks_result)
  end

  test "should destroy gitleaks_result" do
    assert_difference("GitleaksResult.count", -1) do
      delete gitleaks_result_url(@gitleaks_result)
    end

    assert_redirected_to gitleaks_results_url
  end
end
