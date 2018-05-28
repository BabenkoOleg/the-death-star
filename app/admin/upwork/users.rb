ActiveAdmin.register Upwork::User do
  FIELDS = [:email, :sidekiq_jid, :locked, :password, :user_agent, :last_request_at]

  menu label: 'Users', parent: 'Upwork', priority: 1

  permit_params *FIELDS

  config.sort_order = 'id_asc'

  batch_action :lock do |ids|
    batch_action_collection.where(id: ids).update_all(locked: true)
    redirect_to collection_path, notice: 'The users have been locked.'
  end

  batch_action :unlock do |ids|
    batch_action_collection.where(id: ids).update_all(locked: false)
    redirect_to collection_path, notice: 'The users have been unlocked.'
  end

  member_action :lock, method: :put do
    resource.update(locked: true)
    redirect_to admin_upwork_users_path, notice: 'Locked!'
  end

  member_action :unlock, method: :put do
    resource.update(locked: false)
    redirect_to admin_upwork_users_path, notice: 'Unlocked!'
  end

  filter :email
  filter :sidekiq_jid
  filter :locked
  filter :last_request_at

  index do
    selectable_column
    id_column
    column :email
    column :sidekiq_jid
    column :locked
    column :last_request_at
    actions defaults: true do |user|
      if user.locked?
        link_to 'Unlock', unlock_admin_upwork_user_path(user), method: :put
      else
        link_to 'Lock', lock_admin_upwork_user_path(user), method: :put
      end
    end
  end

  show { attributes_table *FIELDS }

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :sidekiq_jid
      f.input :locked
      f.input :user_agent
    end
    f.actions
  end
end
