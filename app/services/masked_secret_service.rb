class MaskedSecretService  
  def self.assign_masked_secret!(obj_with_secret)
    secret_hash = Digest::SHA256.hexdigest(obj_with_secret.secret)
    
    # Find an existing masked secret by hash and if it exists, increment the count
    client = obj_with_secret.client
    raise "Client not found for object with secret" if client.blank?

    masked_secret = MaskedSecret.find_by(secret_hash: secret_hash, client: client)
    if masked_secret.present?
      masked_secret.count += 1
      masked_secret.save!
      return masked_secret
    end

    # If no existing masked secret is found, create a new one 
    masked_secret_params = {
      secret: self.mask_secret(obj_with_secret.secret),
      secret_hash: secret_hash,
      rule_id: obj_with_secret.rule_id,
      client: client,
      count: 1
    }


    masked_secret = MaskedSecret.new(masked_secret_params)    
    masked_secret.save!
    masked_secret
  end

  def self.mask_secret(secret)
    if secret.length < 10
      '*' * (secret.length - 3) + secret[-3..]
    else
      # Strip certificate lines with --- and mask the middle
      trimmed_secret = secret
      if secret.include?("---")
        #grab the first line that doesn't contain --- and use the first 100 chars as the secret
        trimmed_secret = secret.split("\\n").split("\n").select { |line| !line.include?("---") }.join("")[0, 100]
        
        if trimmed_secret.length < 10
          "invalid"
        else
          '*' * 3 + trimmed_secret[-6..]
        end
      else
        trimmed_secret[0, 3] + '*' * 5 + trimmed_secret[-3..]
      end
    end
  end
    
end
