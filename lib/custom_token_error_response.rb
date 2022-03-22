module CustomTokenErrorResponse
    def status
        :unauthorized
    end

    def body
        {
        status: 401,
        message: I18n.t('invalid_login')
        }
    end
end