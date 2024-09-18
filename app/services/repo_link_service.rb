# this service is responsible for creating a link to the repository. 
# It takes a gitleaks result and returns a link to the specific file and commit in the repository.
# Supported repos: github, gitlab. 

class RepoLinkService
  def self.create_link(gitleaks_result)
    return nil if gitleaks_result.nil?

    if gitleaks_result.commit.present? && gitleaks_result.file.present? && gitleaks_result.data_set.source_url.present?
      case gitleaks_result.data_set.repository_type
      when 'github'
        "#{gitleaks_result.data_set.source_url}/blob/#{gitleaks_result.commit}/#{gitleaks_result.file}#L#{gitleaks_result.start_line}"
      when 'gitlab'
        "#{gitleaks_result.data_set.source_url}/-/blob/#{gitleaks_result.commit}/#{gitleaks_result.file}#L#{gitleaks_result.start_line}"
      else
        nil
      end
    else
      nil
    end
  end
end