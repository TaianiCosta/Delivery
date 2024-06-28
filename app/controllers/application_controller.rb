class ApplicationController < ActionController::Base

    def authenticate!
        if request.format == Mime[:json]
            check_token!
        else
            authenticate_user!
            check_user_discarded if user_signed_in?
        end
    end

    def current_user
        if request.format == Mime[:json]
            @user
        else
            super
        end
    end

    def current_credential
        return nil if request.format != Mime[:json]
        
        Credential.find_by(key: request.headers["X-API-KEY"]) || Credential.new
    end
        
    private
    
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
            flash[:alert] = "Sua conta está desativada. Entre em contato com o suporte."
            redirect_to root_path
        end
    end

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

    def set_locale!
        if params[:locale].present?
            I18n.locale = params[:locale]
        end
    end
end
