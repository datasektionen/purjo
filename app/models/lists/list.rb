class List < ActiveRecord::Base
  include Ior::DigestHelper
  
  named_scope :with_permission, lambda { |person| { 
    :select => 'lists.*',
    :joins => 'LEFT JOIN list_permissions ON lists.id = list_permissions.list_id',
    :conditions => ['lists.creator_id = :person_id OR list_permissions.person_id = :person_id', {:person_id => person.id}]
  }}
  
  has_many :list_fields, :order => 'position ASC'
  has_many :list_entries
  
  has_many :permissions, :class_name => 'ListPermission'
  has_many :people_with_permission, :through => :permissions, :source => :person
  
  belongs_to :creator, :class_name => 'Person'

  before_create :set_identifier
  after_save :remove_deleted_fields, :remove_permissions
  
  def set_identifier
    self.identifier = generate_digest
  end

  def list_fields_params=(list_fields_params)
    list_fields_params.each_with_index do |params, position|
      # convert checkboxes and radios to key1|key2|... values.
      params[:value].collect{|k, v| k}.join('|') if params[:value].is_a? Hash
      
      # update(or set) the fields position
      params.merge!({:position => position})
      
      if params[:id]
        list_field = list_fields.find(params[:id])

        params.delete(:id)
        
        list_field.update_attributes(params)
      else
        list_fields.create(params)
      end
    end
  end
  
  def delete_fields=(deleted_ids)
    @delete_fields = deleted_ids
  end
  
  def has_entries?
    !list_entries.empty?
  end
  
  def people
    
  end
  
  def permissions_to_remove=(permission_ids)
    @permissions_to_remove = permission_ids
  end
  
  def people=(people)
    people.split(/\s+/).each do |username|
      person = Person.find_by_kth_username(username)
      permissions.build(:person => person)
    end
  end
  
  def has_permission?(person)
    person.admin? || creator == person || people_with_permission.include?(person)
  end
  
  protected
  def remove_deleted_fields
    return if @delete_fields.blank?
    ListField.destroy(@delete_fields)
  end  
  
  def remove_permissions
    return if @permissions_to_remove.blank?
    ListPermission.destroy(@permissions_to_remove)
  end
end
