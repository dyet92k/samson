# frozen_string_literal: true
module SamsonRollbarHook
  class Engine < Rails::Engine
  end
end

Samson::Hooks.view :stage_form, 'samson_rollbar/stage_form'

Samson::Hooks.callback :stage_permitted_params do
  {
    rollbar_webhooks_attributes: [
      :id, :_destroy,
      :webhook_url, :access_token, :environment
    ]
  }
end

Samson::Hooks.callback :after_deploy do |deploy|
  deploy.stage.rollbar_webhooks.each do |webhook|
    RollbarNotification.new(
      webhook_url: webhook.webhook_url,
      access_token: webhook.resolved_access_token,
      environment: webhook.environment,
      revision: deploy.reference
    ).deliver
  end
end

Samson::Hooks.callback :stage_clone do |old_stage, new_stage|
  new_stage.rollbar_webhooks.build(
    old_stage.rollbar_webhooks.map { |s| s.attributes.except("id", "created_at", "updated_at") }
  )
end