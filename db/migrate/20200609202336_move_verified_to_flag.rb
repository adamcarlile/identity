class MoveVerifiedToFlag < ActiveRecord::Migration[6.0]
  def change
    User.all.each do |user|
      if user.state == "verified"
        user.update({state: "active", verified: true})
      elsif user.state == "unverified"
        user.update({state: "pending", verified: false})
      end
    end
  end
end
