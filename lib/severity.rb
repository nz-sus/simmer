module Severity
  SEVERITIES = {    
    'SAFE' => 0,
    'UNKNOWN' => 1,
    'SUSPICIOUS' => 2,
    'LOW' => 3,
    'MEDIUM' => 4,
    'HIGH' => 5,
    'CRITICAL' => 6
  }

  def self.above_severity(severity_name)
    severity_value = SEVERITIES.fetch(severity_name, 0)
    SEVERITIES.keys.select { |k| SEVERITIES.fetch(k, 0) >= severity_value }
  end
end