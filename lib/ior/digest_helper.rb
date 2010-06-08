module Ior
  module DigestHelper
    def generate_digest
      Digest::SHA1.hexdigest(Time.now.to_s.split(" ").sort_by {rand}.join)
    end
  end
end