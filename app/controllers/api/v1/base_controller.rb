class Api::V1::BaseController < ApplicationController::API
    before_action :set_variables

    # Asignar variables globales
    def set_variables
        # Zona horaria
        @TZ ||= "Monterrey"
    end

    # Colocar usuario desde token
    def current_user
        @current_user ||= begin
            if doorkeeper_token
                User.find(doorkeeper_token.resource_owner_id)
            end
        end
    end

    def validate_user_types(*user_types)
        if user_types.include?(current_user.user_type)
            return true
        else
            render json: {
            status: :forbidden,
            message: I18n.t("user_unauthorized")
            }, status: :forbidden and return false
        end
    end

end
