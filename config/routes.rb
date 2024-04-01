Rails.application.routes.draw do
  # get 'm_users/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'change_password/new'
  get 'm_users/create' 
  get 'signin' =>  'sessions#new'
  post 'signin' =>  'sessions#create'
  delete 'logout' =>  'sessions#destroy'
  get 'home' =>  'static_pages#home'
  post 'change_password' => 'change_password#update'
  get 'check_user' =>  'sessions#checkuser'




  # DirectMessages Controller
  post 'directmsg' => 'direct_messages#show'
  delete '/directmsg/:id' => "direct_messages#deletemsg"

  # TDirectStarMsg Controller
  post '/star' => 't_direct_star_msg#create'
  delete '/unstar' => 't_direct_star_msg#destroy'

  # TDirectStarThread Controller
  post '/starthread' => 't_direct_star_thread#create'
  delete '/unstarthread' => 't_direct_star_thread#destroy'

  # DirectMessage Controller
  post '/directthreadmsg' => 'direct_messages#showthread'
  delete '/directthreadmsg' => 'direct_messages#deletethreadmsg'
  
  # TDirectMessage Controller
  get '/directthreadmsg' => 't_direct_messages#show'

  # All Unread route
  get 'thread' => 'thread#show'
  get 'allunread' => 'all_unread#show'
  get 'starlists' => 'star_lists#show'
  get 'mentionlists' => 'mention_lists#show'

  get 'usermanage' => 'user_manage#usermanage'
  get 'edit' => 'user_manage#edit'
  get 'update' => 'user_manage#update'

    #channel routes
    get 'm_channels/channelshow' => 'm_channels#show'
    get 'm_channels/channeledit/:id' => 'm_channels#edit'
    put 'm_channels/channelupdate/:id' => 'm_channels#update'
    post '/delete_channel' => 'm_channels#delete'
    post '/channelUserJoin' => 'm_channels#join'
  
    #channel users routes
    get '/channelusers' => 'channel_user#show'
    delete '/channeluser/destroy' => 'channel_user#destroy'
    post '/channeluser/create' => 'channel_user#create'
    ############################
  
    ##t-group-message
    post '/groupmsg' => 'group_message#show'
    post '/delete_groupmsg' => "group_message#deletemsg"
    ##############################
  
    ##t-group-message
    post '/groupstarmsg' => 't_group_star_msg#create'
    post '/groupunstar' => 't_group_star_msg#destroy'
    ##############################
  
    ##### group thread message #####
    post 'groupthreadmsg' => 'group_message#showthread'
    post '/groupstarthread' => 't_group_star_thread#create'
    post '/groupunstarthread' => 't_group_star_thread#destroy'
    post '/delete_groupthread' => "group_message#deletethread"  
  
    #####
  
    post '/t_group_message' => 't_group_messages#show'

    post 'member_invitation' => 'member_invitation#invite'

    get 'confirminvitation' => 'm_users#confirm'
    get 'invitationconfirm'  => 'm_users#invitation_confirm'
  
    get 'usermanage' => 'user_manage#usermanage'
    post 'edit/:id' => 'user_manage#edit'
    post 'update/:id' => 'user_manage#update'

    # get 'm_users_show' => 'm_users#show'

    get 'refresh_direct' => 'm_users#refresh_direct'
    get 'refresh_group' => 'm_channels#refresh_group'

  
  # Defines the root path route ("/")
  # root "posts#index"
  resources :m_workspaces
  resources :m_users
  resources :direct_messages
  resources :t_direct_messages
  resources :m_channels

end