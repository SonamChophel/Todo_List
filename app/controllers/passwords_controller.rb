class PasswordsController < ApplicationController

    before_action :authorized, only: [:update], except: [:forgot, :reset]

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
            render json: { success: true, message: "OTP has been sent to your registered email" }, status: 200
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
        user = User.find_by(email: params[:email])
        if user
            if !params[:password].present?
                render json: {error: 'No matching password found'}, status: :unprocessable_entity
                return
            end

            if user.reset_password!(params[:password])
                render json: {status: 'Password updated successfully'}, status: :ok
            else
                render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: { error: 'Email does not match'}, status: 400
        end
    end
end
