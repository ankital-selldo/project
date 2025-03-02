class EventUploader < CarrierWave::Uploader::Base
 
  include CarrierWave::MiniMagick
  
  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  
    %w[jpg jpeg gif png]
  end

end
