class JobAd < ActiveRecord::Base
  belongs_to :created_by, :class_name => 'Person'
  acts_as_textiled :description
  def types
    ts = []
    ts << "Heltid" if full_time?
    ts << "Deltid" if part_time?
    ts << "Exjobb" if thesis?
    ts
  end
end
