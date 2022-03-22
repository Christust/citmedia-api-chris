class ApplicationController < ActionController::API
    # Sentry Raven
    before_action :set_sentry_context

    private

    def set_sentry_context
        if ENV["RAILS_ENV"] == "production"
            Raven.extra_context(params: params.to_unsafe_h, url: request.url)
            # Sentry.with_scope do |scope|
            #   scope.set_extras(params: params.to_unsafe_h, url: request.url)
            # end
        end
    end
end
