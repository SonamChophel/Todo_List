class ApplicationController < ActionController::API

    before_action :authorized

    def encode_token(payload)
        exp = 12.hours.from_now
        payload[:exp] = exp.to_i
        JWT.encode(payload, 'HKL4A2S23DJK8SH')
    end

    def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
            JWT.decode(token, 'HKL4A2S23DJK8SH', true, algorithm: 'HS256')
        rescue JWT::DecodeError
            nil
        end
        end
    end


    #to check whether it's a admin or not, if role=1 then admin else not
    def role
        decoded_token[0]["role"]
    end

    def logged_in_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            puts("USER ID: ", user_id)
            @user = User.find_by(id: user_id)
        end
    end

    def logged_in?
        !!logged_in_user
    end

    def authorized
        render json: { success: false, message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

    
end
