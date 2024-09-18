require "application_system_test_case"

class GitleaksResultsTest < ApplicationSystemTestCase
  setup do
    @gitleaks_result = gitleaks_results(:one)
  end

  test "visiting the index" do
    visit gitleaks_results_url
    assert_selector "h1", text: "Gitleaks results"
  end

  test "should create gitleaks result" do
    visit gitleaks_results_url
    click_on "New gitleaks result"

    fill_in "Author", with: @gitleaks_result.author
    fill_in "Commit", with: @gitleaks_result.commit
    fill_in "Date", with: @gitleaks_result.date
    fill_in "Description", with: @gitleaks_result.description
    fill_in "Email", with: @gitleaks_result.email
    fill_in "End column", with: @gitleaks_result.end_column
    fill_in "End line", with: @gitleaks_result.end_line
    fill_in "Entropy", with: @gitleaks_result.entropy
    fill_in "File", with: @gitleaks_result.file
    fill_in "Fingerprint", with: @gitleaks_result.fingerprint
    fill_in "Log entry", with: @gitleaks_result.log_entry_id
    fill_in "Match", with: @gitleaks_result.match
    fill_in "Message", with: @gitleaks_result.message
    fill_in "Rule", with: @gitleaks_result.rule_id
    fill_in "Secret", with: @gitleaks_result.secret
    fill_in "Start column", with: @gitleaks_result.start_column
    fill_in "Start line", with: @gitleaks_result.start_line
    fill_in "Symlink file", with: @gitleaks_result.symlink_file
    fill_in "Tags", with: @gitleaks_result.gltags
    click_on "Create Gitleaks result"

    assert_text "Gitleaks result was successfully created"
    click_on "Back"
  end

  test "should update Gitleaks result" do
    visit gitleaks_result_url(@gitleaks_result)
    click_on "Edit this gitleaks result", match: :first

    fill_in "Author", with: @gitleaks_result.author
    fill_in "Commit", with: @gitleaks_result.commit
    fill_in "Date", with: @gitleaks_result.date
    fill_in "Description", with: @gitleaks_result.description
    fill_in "Email", with: @gitleaks_result.email
    fill_in "End column", with: @gitleaks_result.end_column
    fill_in "End line", with: @gitleaks_result.end_line
    fill_in "Entropy", with: @gitleaks_result.entropy
    fill_in "File", with: @gitleaks_result.file
    fill_in "Fingerprint", with: @gitleaks_result.fingerprint
    fill_in "Log entry", with: @gitleaks_result.log_entry_id
    fill_in "Match", with: @gitleaks_result.match
    fill_in "Message", with: @gitleaks_result.message
    fill_in "Rule", with: @gitleaks_result.rule_id
    fill_in "Secret", with: @gitleaks_result.secret
    fill_in "Start column", with: @gitleaks_result.start_column
    fill_in "Start line", with: @gitleaks_result.start_line
    fill_in "Symlink file", with: @gitleaks_result.symlink_file
    fill_in "Tags", with: @gitleaks_result.gltags
    click_on "Update Gitleaks result"

    assert_text "Gitleaks result was successfully updated"
    click_on "Back"
  end

  test "should destroy Gitleaks result" do
    visit gitleaks_result_url(@gitleaks_result)
    click_on "Destroy this gitleaks result", match: :first

    assert_text "Gitleaks result was successfully destroyed"
  end
end
