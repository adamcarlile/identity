class UserClaimsPresenter < SimpleDelegator

  def sub
    id
  end

  def org
    trades.map(&:as_json)
  end

  def family_name
    last_name
  end

  def given_name
    first_name
  end

  def email_verified
    verified?(:email)
  end

  def middle_name
    nil
  end

  def name
    [given_name, middle_name, family_name].compact.join(' ')
  end

  def nickname
    nil
  end

  def preferred_username
    nil
  end

  def profile
    nil
  end

  def website
    nil
  end

  def picture
    nil
  end

  def gender
    nil
  end

  def birthdate
    nil
  end

  def zoneinfo
    nil
  end

  def locale
    nil
  end

  def phone_number
    mobile_number
  end

  def phone_number_verified
    verified?(:mobile_number)
  end

  def address
    {
      formatted: nil,
      street_address: nil,
      locality: nil,
      region: nil,
      country: nil
    }.reject { |k, v| v.blank? }
  end

end
