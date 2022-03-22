class Api::V1::ClinicsController < Api::V1::BaseController
    before_action :doorkeeper_authorize!
    before_action -> { validate_user_types('admin') }, only: []

    def index
        # Obtener clinicas
        clinics = Clinic.order(name: :asc)
        
        # Armar lista de clinicas
        list_clinics = []
        clinics.each do |clinic|
          list_clinics << {
            id: clinic.id,
            name: clinic.name
          }
        end
    
        # Responder lista de clinicas
        render json: {
          clinics: list_clinics
        }, status: :ok
      end
    
      def create
        # Crear clinica
        clinic = Clinic.new(clinic_params)
    
        # Guardar clinica
        if clinic.save
          # Se guardo
          render json: {
            status: :ok
          }, status: :ok
        else
          # No se guardo
          render json: {
            message: I18n.t("clinic_not_saved")
          }, status: :bad_request
        end
      end
    
      def update
        # Actualizado de nombre
        @clinic.name = clinic_params[:name]
    
        # Guardado de actualizacion
        if @clinic.save
          # Se guardo
          render json: {
            status: :ok
          }, status: :ok
        else
          # No se guardo
          render json: {
            message: I18n.t("clinic_not_updated")
          }, status: :bad_request
        end
      end
end
