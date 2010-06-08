namespace :studs do
  task :setup_cvs_for_travel_years => [:environment] do
    ty_2009 = TravelYear.create!(:year => 2009, :layout => 'studs2009')
    TravelYear.create!(:year => 2010, :layout => 'studs2010')
    Cv.all.each do |cv|
      cv.travel_year = ty_2009
      cv.save!
    end
  end
end