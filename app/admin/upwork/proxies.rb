ActiveAdmin.register Upwork::Proxy do
  menu label: 'Proxies', parent: 'Upwork', priority: 10

  config.sort_order = 'id_asc'

  permit_params :host, :port, :state, :busy, :last_request_at, :got_recaptcha, :got_recaptcha_at

  filter :state, as: :select
  filter :busy, as: :select

  index do
    selectable_column
    id_column
    column :address do |proxy|
      link_to "#{proxy.host}:#{proxy.port}", admin_upwork_proxy_path(proxy)
    end
    column :state
    column :busy
    column :got_recaptcha
    actions
  end

  form do |f|
    f.inputs do
      f.input :host
      f.input :port
      f.input :state, as: :select, include_blank: false
      f.input :got_recaptcha
    end
    f.actions
  end
end
