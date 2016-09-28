# encoding: utf-8
class AnonymousPerson
  extend ActiveModel::Naming

  def first_name
    "Anonym"
  end

  def last_name
    "Användare"
  end

  def name
    first_name
  end

  def to_s
    "Anonym"
  end

  def id
    nil
  end

  # Use some dynamic programming voodo for syntactic sugar, again, DRY IT UP!
  Role.all.each do |role|
    define_method "#{role.to_s}?" do
      false
    end
  end

  def has_role?(role)
    false
  end

  def anonymous?
    true
  end

  def has_feature?(feature)
    false
  end
end
