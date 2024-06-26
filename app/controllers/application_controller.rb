class ApplicationController < ActionController::Base
    # Métodos definidos aqui podem ser usados em qualquer controller
    def authenticate!
        if request.format == Mime[:json]
            check_token!
        else
            authenticate_user!
            check_user_discarded if user_signed_in?
        end
    end

    # Sobrescreve o método current_user herdado do devise
    def current_user
        if request.format == Mime[:json]
            @user
        else
            super
        end
    end

    # Recupera a credencial da aplicação que está usando a api
    def current_credential
        return nil if request.format != Mime[:json]
        
        Credential.find_by(key: request.headers["X-API-KEY"]) || Credential.new
    end

    def set_locale!
        if params[:locale].present?
            I18n.locale = params[:locale]
        end
    end
        
    private
    
    # Verifica a existência e validade do token
    def check_token!
        if user = authenticate_with_http_token { |t, _| User.from_token(t) }
            @user = User.new(id: user[:id], role: user[:role], email: user[:email])
        else
            render json: {message: "Not authorized"}, status: 401
        end
    end

    def check_user_discarded
        if user_signed_in? && current_user.discarded?
            sign_out current_user
            flash[:alert] = "Sua conta foi desativada. Entre em contato com o suporte para obter mais informações."
            redirect_to root_path
        end
    end
    
    # Método para filtrar apenas buyers e admin
    def only_buyers_or_admin!
        is_buyer = (current_user && current_user.buyer?) && current_credential.buyer?
        is_admin = current_user && current_user.admin?
    
        if !is_buyer || !is_admin
          render json: {message: "Not authorized"}, status: 401
        end
    end

    def is_buyer?
        current_credential && current_credential.buyer?
    end


end
