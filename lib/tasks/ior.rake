namespace :ior do
  namespace :cms do
    task :create_root => [:environment] do
      TextNode.create!(:name => 'root', :contents => 'this is teh root.')
    end
  end

  namespace :news do
    task :create_tags => :environment do
      %w(DIU DREK Sektionen DKM Spex ESCapo Extern Ior Jäm Mottagningen Näringsliv Prylis QN Redaktionen Idrott SN Studs SVL Val).each do |tag|
        Tag.create(:name => tag) unless Tag.find(:first, :conditions => {:name => tag})
      end
    end
  end

  namespace :security do
    task :create_roles => [:environment] do
      [:admin, :editor].each do |r|
        Role.create(:name => r.to_s)
      end
    end
  end
end