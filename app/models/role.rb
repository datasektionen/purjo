class Role < ActiveRecord::Base
  has_many :memberships
  has_many :persons, :through => :memberships

  def to_s
    name
  end
end
