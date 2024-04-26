module APIRequestHelpers
    def authenticate_user(user)
        # Supondo que você use Devise com Warden para autenticação em testes
        login_as(user, scope: :user)
        # Supondo que você use JWT para gerar tokens
        "Bearer #{user.generate_jwt_token}"
      end

      # Configura headers para autenticação com token
  def authenticated_header(user)
    { 'Authorization' => authenticate_user(user) }
  end

  # Configura headers para JSON
  def json_header
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  # Envia uma requisição GET autenticada
  def get_authenticated(url, user, params = {})
    get url, params: params, headers: authenticated_header(user).merge(json_header)
  end

  # Envia uma requisição POST autenticada
  def post_authenticated(url, user, data = {})
    post url, params: data.to_json, headers: authenticated_header(user).merge(json_header)
  end

  # Parse JSON response to Ruby hash
  def json_response
    JSON.parse(response.body)
  end
end