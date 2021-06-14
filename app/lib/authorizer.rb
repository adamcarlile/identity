class Authorizer

  def initialize(permitted_domains)
    @permitted_domains = [permitted_domains].flatten
  end

  def permitted?(email)
    @permitted_domains.include?(Mail::Address.new(email).domain)
  end

end