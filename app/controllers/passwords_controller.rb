class PasswordsController < ApplicationController

    before_action :authorized, except: [:forgot, :reset, :update]

    def forgot
        if params[:email].blank?
            return render json: { success: false, error: "Email not present" }, status: 400
        end

        user = User.find_by(email: params[:email].downcase)

        if user.present?
            token = user.generate_password_token!

        # send token in email
        subject = "Token"
        body = "This is your TOKEN to reset your password #{token} use it before it expires"
        ApplicationMailer.send_email(user, subject, body).deliver_now
            render json: { success: true, message: "OTP has sent to your registered email" }, status: 200
        else
            render json: { success: false, error: "Email address not found. Please check and try again." }, status: 404
        end
    end

    def reset
        token = params[:token].to_s
        if params[:email].blank?
            return render json: { success: false, error: "Token not present" }, status: 404
        end

        user = User.find_by(reset_password_token: token)

        if user.present? && user.password_token_valid?
            if user.reset_password!(params[:password])
                render json: { success: true, message: "Password reset successfull" }, status: 200
            else
                render json: { success: false, error: user.errors.full_messages }, status: 422
            end
        else
            render json: { success: false, error: "Link not valid or expired. Try generating a new link." }, status: 404
        end
    end

    def update
        if !params[:password].present?
            render json: {error: 'Password not present'}, status: :unprocessable_entity
            return
        end
      
        if current_user.reset_password(params[:password])
            render json: {status: 'ok'}, status: :ok
        else
            render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
        end
    end
end
