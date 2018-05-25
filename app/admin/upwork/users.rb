ActiveAdmin.register Upwork::User do
  FIELDS = [:email, :busy, :password, :user_agent, :last_request_at]

  menu label: 'Users', parent: 'Upwork', priority: 1

  permit_params *FIELDS

  config.sort_order = 'id_asc'

  filter :email
  filter :busy
  filter :last_request_at

  index do
    selectable_column
    id_column
    column :email
    column :busy
    column :last_request_at
    actions
  end

  show { attributes_table *FIELDS }

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :busy
      f.input :user_agent
    end
    f.actions
  end
end
