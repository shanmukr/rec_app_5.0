class Uniqid < ApplicationRecord

  has_one :requirement
  has_one :resume
  
	validates_uniqueness_of :name

	def Uniqid.generate_unique_id(name)
    # merge multiple spaces into '1' and remove spaces at the end
    goodname = name.squeeze(" ").strip.downcase
    # Replace white-space with '_'
    goodname = goodname.gsub(/\s+/, '_')
    # Remove non-word characters
    goodname = goodname.gsub(/[^\w]/, '')
    unique_id = goodname
    suffix = 0
    while (entity = Uniqid.find_by_name(unique_id))
      unique_id = goodname + "_" + suffix.to_s
      suffix += 1
		end
    uniqid = Uniqid.new
		uniqid.name = unique_id 
		uniqid.save
    return [ uniqid.id, uniqid.name ]
  end
end
