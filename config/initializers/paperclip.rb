# Make paperclip work with legacy storage system
Paperclip.interpolates(:parent_id_partition) do |attachment, style_name|
  ("%08d" % attachment.instance.parent.id.to_s).scan(/\d{4}/).join("/")
end