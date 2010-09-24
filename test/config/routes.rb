ActionPresenter::Application.routes.draw do
root :to => "welcome#index"
match ':controller(/:action(/:id(.:format)))'
end
