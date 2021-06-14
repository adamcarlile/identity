COUNTRY_SELECT = ISO3166::Country.all.each.with_object(Hash.new) do |x, h| 
  h[x.alpha2] = "#{x.emoji_flag} #{x.name} (#{x.country_code})"
end