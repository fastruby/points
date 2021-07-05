class Token
  def self.issue(payload, algorithm = "MD5")
    Object.const_get("Digest::#{algorithm}").hexdigest(payload)
  end
end
