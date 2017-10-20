Rails.application.routes.draw do
  get 'home/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :resumes do
    collection do
      post 'new', 
			     'edit',
					 "destroy", 
					 'update', 
					 'resume_search', 
					 'mark_as_joining', 
					 'comment_new', 
					 'message_new', 
					 "hr_forwards", 
					 'message_delete', 
					 'manager_shortlists', 
					 'employee_select', 
					 'portals_select', 
					 'agencies_select', 
					 'req_match_new', 
					 'manager_holds', 
					 'manager_offer',
					 'manager_joining',
					 'req_match_hold', 
					 'manager_forward_hold', 
					 'interview_add',
					 'create_new_interview',
					 'decline_interview',
					 'create_feedback',
					 'resume_status_to_rejected'
      get  'show', 
			     'resumes_new', 
					 'forwarded', 
					 'shortlisted', 
					 'hold', 
					 'scheduled_interviews', 
					 'my_interviews', 
					 'resumes_offered', 
					 'resumes_joining', 
					 'my_resumes', 
					 'resumes_rejected', 
					 'resumes_future', 
					 'move_to_future', 
					 'reject_resume',
					 "show_resumes_comments", 
					 "decline_resume",
					 "feedbacks",
					 'show_message', 
					 'show_reqs', 
					 'inbox', 
					 'outbox', 
					 'trash', 
					 'employee_all', 
					 'agencies_all', 
					 'portals_all',
					 'direct'
    end
 end
  
  resources :home do
    collection do
      post 'emp_validation'
			get 'logout'
    end
  end
  
  resources :employees do
    collection do
      post 'show'
			get  'login_to_selected_employee',
			     'my_employees'
    end
  end
  
  resources :agencies do
    collection do
      post 'new', 
			     'edit', 
					 'destroy', 
					 'update'
    end
  end

  resources :requirements do
    collection do
      post 'show', 
			     'active', 
					 "new", 
					 "destroy", 
					 'search', 
					 "update_to", 
					 'create', 
					 'edit'
      get "req_analysis", 
			    "closed", 
					'all', 
					'testing',
          'my_requirements'
      get :autocomplete_employee_name
    end 
  end 
  
  resources :designations do
    collection do
      post 'new', 
			     'edit', 
					 'destroiy', 
					 'update'
      get  'show'
    end
  end
  
  resources :groups do
    collection do
      post 'new', 
			     'edit', 
					 "destroy", 
					 'update'
      get  'show'
    end
  end
  
  resources :portals do
    collection do
      post 'new', 
			     'edit', 
					 "destroy", 
					 'update'
    end
  end

end
