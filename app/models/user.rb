class User < ApplicationRecord
    has_secure_password

    belongs_to :clinic, optional: true
    has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks
    has_many :access_tokens,
            class_name: 'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :delete_all # or :destroy if you need callbacks

    validates :name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :user_type, presence: true

    enum title: {dr: 1, dra:2}
    enum user_type: {admin: 1, cacit: 2, medic: 3}

    def complete_name
        title = ""
        if self.title.present?
            title = I18n.t("title.#{self.title}")
        end

        if title.present?
            return "#{title} #{self.name} #{self.last_name}"
        else
            return "#{self.name} #{self.last_name}"
        end
    end

    def simple_user_type
        case self.user_type
        when 'admin'
          'admin'
        when 'cacit'
          'cacit'
        when 'medic'
          'medic'
        end
    end
end
