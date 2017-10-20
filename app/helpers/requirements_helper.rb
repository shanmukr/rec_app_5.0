module RequirementsHelper

  def get_forwards_count(req)
	  req.forwards.where(:status => "FORWARDED").size
  end
  
	def get_shortlisted_count(req)
	  req.req_matches.where(:status => "SHORTLISTED").size
  end

end
