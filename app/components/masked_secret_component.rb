# frozen_string_literal: true

class MaskedSecretComponent < ViewComponent::Base
  def initialize(masked_secret:, for_export:)
    @masked_secret = masked_secret
    @gitleaks_results = masked_secret.gitleaks_results.sort_by(&:date).reverse
    @for_export = for_export
  end

  attr_reader :gitleaks_results
end
