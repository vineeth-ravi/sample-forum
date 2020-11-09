Rails.application.routes.draw do
  get 'login/' => 'login#get'
  post 'login/authenticate'
  get 'login/logout'
  post 'login/signup'

  get 'question/list'
  post 'question/update'
  get 'question/download'
  get 'question/new'
  post 'question/create'
  post 'question/post_comment'
  post 'question/post_action'
  get 'question/get_comments/:id' => 'question#get_comments'
  delete 'question/:id/delete' => 'question#delete'

  get 'profile/:id' => 'profiles#get_profile'
  get 'profile/:id/questions' => 'profiles#get_questions_by_user'
  get 'profile/:id/answers' => 'profiles#get_answers_by_user'
  get 'profile/:id/following' => 'profiles#get_following'
  get 'profile/:id/followers' => 'profiles#get_followers'
  post 'profile/update_following' => 'profiles#update_following'


end
