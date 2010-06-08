class ListEntriesController < ApplicationController
  require_role 'editor', :only => :edit

  def show
    @list_entry = ListEntry.find(params[:id])
    raise Ior::Security::AccessDenied if not authorized_user
  end

  def edit
    @list_entry = ListEntry.find(params[:id])
    raise Ior::Security::AccessDenied if not authorized_user
  end

  def create
    @list = List.find(params[:list_id])

    # I min värld borde nedanstående två rader vara identiska med 
    #   @entry = @list.list_entries.new(params[:list_entry]).
    # Tydligen lever jag och rails inte i samma värld, då det inte fungerar...
    # /spatrik
    @entry = @list.list_entries.new
    @entry.attributes = params[:list_entry]
    
    unless Person.current.anonymous?
      @entry.person = Person.current
    end
    @entry.save!
    
    flash[:notice] = "Tack för att du fyllt i listan."
    
    redirect_back_or_default("/")
  end

  # Sann om man är någon av följande:
  # Admin, ägaren till listan, eller har fått rätitgheter på listan.
  # TODO: Byt till (u)id-nummer i stället, kan bli problem med anv. med samma namn.
  def authorized_user
    Person.current.admin? or
      @list_entry.list.creator == Person.current or
      @list_entry.list.people_with_permission.include?(Person.current)
  end
end
