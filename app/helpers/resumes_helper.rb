module ResumesHelper
  def resume_show_status_text(action)
    if action == "resumes_new"
      return "New Resumes"
    elsif action == "forwarded"
      return "Forwarded Resumes"
    elsif action == "shortlisted"
      return "Shortlisted Resumes"
    elsif action == "hold"
      return "Hold Resumes"
    elsif action == "my_resumes"
      return "Your referral resumes"
    elsif action == "resumes_rejected"
      return "Rejected resumes"
    elsif action == "resumes_future"
      return "Future Resumes"
    end
  end
end
