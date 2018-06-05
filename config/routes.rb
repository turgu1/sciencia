Rails.application.routes.draw do

  root "home#index"

  resources :issues do
    resources :comments, shallow: true
    member do
      post 'state_change'
    end
  end

  devise_for :users, controllers: {registrations: "registrations"}

  resources :users do
    member do
      get   'change_password_for'
      post  'do_change_password_for'
    end
  end

  resources :home, only: [:index] do
    collection do
      get 'about'
      get 'compute_counts'
    end
  end

  resources :organisations do
    resources :people, shallow: true do
      member do
        get  'replace'
        get  'move'
        post 'do_move'
      end
      collection do
        post 'replace_with'
      end
    end
    member do
      get 'replace'
    end
    collection do
      post 'replace_with'
    end
  end

  resources :people, only: [ :index ] do
    member do
      get  'publication_list'
      post 'publication_list'
    end
  end

  resources :documents, shallow: true do
    resources :authors
    resources :attachments, only: [] do
      member do
        get 'download'
      end
    end
    member do
      get 'show_and_return'
    end
    collection do
      get 'check_duplicate'
    end
  end

  resources :events

  resources :document_categories

  resources :document_sub_categories

  resources :document_types do
    collection do
      get 'change'
    end
  end

  resources :peer_reviews

  resources :security_classifications

  namespace :dictionaries do
    resources :editors, :institutions, :journals, :orgs, :publishers, :schools, :languages do
      member do
        get 'replace'
      end
      collection do
        post 'replace_with'
      end
    end
  end

end
