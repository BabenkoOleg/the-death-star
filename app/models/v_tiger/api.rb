module VTiger
  class Api
    attr_accessor :api_url, :email, :access_key, :challenge_token, :session_name, :user_id

    def initialize
      @api_url = "#{TheDeathStar::Application.credentials.v_tiger_host}/webservice.php?"
      @email = TheDeathStar::Application.credentials.v_tiger_email
      @access_key = TheDeathStar::Application.credentials.v_tiger_access_key
    end

    def authorize!
      response = RestClient.get("#{api_url}operation=getchallenge&username=#{email}")

      @challenge_token = JSON.parse(response.body)['result']['token']

      response = RestClient.post(api_url, {
        operation: 'login',
        username: email,
        accessKey: Digest::MD5.hexdigest(challenge_token + access_key)
      })

      result = JSON.parse(response.body)['result']

      @session_name = result['sessionName']
      @user_id = result['userId']
    end

    def query(q)
      RestClient.get(api_url, params: {
        operation: 'query',
        sessionName: session_name,
        query: q
      })
    end

    def upload(client)
      body = { sessionName: session_name }

      vtiger_client = client.vtiger_id ? retrieve(client.vtiger_id) : nil

      if vtiger_client.present?
        body[:operation] = 'update'
        body[:element] = client.vtiger_format_for_update
        body[:element][:lastname] = vtiger_client['lastname']
      else
        body[:operation] = 'create'
        body[:elementType] = 'Leads'
        body[:element] = client.vtiger_format_for_create
      end

      body[:element][:assigned_user_id] = @user_id
      body[:element] = body[:element].to_json

      response = JSON.parse(RestClient.post(api_url, body))

      if client.vtiger_id != response['result']['id'].to_i
        client.update(vtiger_id: response['result']['id'])
      end
    end

    def create(type, element)
      body = {
        sessionName: session_name,
        operation: 'create',
        elementType: type,
        element: element
      }
      body[:element]['assigned_user_id'] = @user_id
      body[:element] = body[:element].to_json

      JSON.parse(RestClient.post(api_url, body))
    end

    def retrieve(id)
      response = RestClient.get(api_url, params: {
        operation: 'retrieve',
        sessionName: session_name,
        id: id
      })

      response = JSON.parse(response)

      response['success'] ? response['result'] : nil
    end

    def describe(type)
      RestClient.get(api_url, params: {
        operation: 'describe',
        sessionName: session_name,
        elementType: type
      })
    end
  end
end
