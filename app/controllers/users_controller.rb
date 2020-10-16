class UsersController < ApplicationController

    before_action :authorized, only: [:auto_login, :show, :update, :destroy]

    # REGISTER
    def register

        # @user = User.where(email: params[:email])

        # if @user
            @user = User.create(user_params)

            if @user.valid?
                payload = { user_id: @user.id, role: @user.role}
                token = encode_token(payload)
                subject = "Registration"
                body = "Signup successful!! Now you can create your TO-DO List"
                ApplicationMailer.send_email(@user, subject, body).deliver_now
                render json: { success: true, message: "Registered successfully", user: @user, token: token }, status: 201
            else
                render json: { success: false, message: "Registration not successful" }, status: 400
            end
        # else
        #     render json: { success: false, message: "User already exist"}, status: 400
        # end
    end

    # LOGGING IN
    def login
        @user = User.find_by(email: params[:email])

        # puts('user: ', params )
        
        if @user && @user.authenticate(params[:password])
            payload = { user_id: @user.id, role: @user.role }
            token = encode_token(payload)
            render json: {success: true, message: "Login Successful", user: @user, token: token}, status: 200
        else
            render json: {success: false, error: "Invalid email or password"}, status: 401
        end
    end


    #Auto login users if they are already logged in
    def auto_login
        render json: {success: true, user: @user}, status: 200
    end


    def show_all
        @users = User.all
        if @users
            render json: { success: true, message: "Listing all Users", user: @users }, status: 200
        else
            render json: { success: false, message: "No users found" }, status: 400
        end
    end

    def show
        @user = User.find(params[:id])
        
        render json: { success: true, message: "User Detail", user: @user }, status: 200
    end

    def update
        @user = User.find(params[:id])
        if @user
            @user.update(user_params)
            render json: { success: true, message: "User updated successfully", user: @user}, status: 200
        else
            render json: { success: false, error: "Unable to update user"}, status: 400
        end
    end

    def destroy
        if role
            @user = User.find(params[:id])
            if @user
                @user.destroy
                render json: { success: true, message: "User deleted successfully"}, status: 200
            else
                render json: { success: false, error: "User not found"}, status: 404
            end
        else
            render json: { success: false, error: "You are not authorised to perform this task"}, status: 401
        end
    end

    def logout
        @user = User.find_by(email: params[:email])
        if @user
            user.authentication_token = nil
            user.save
            render json: { message: "Logged out successfully"}, status: 200
        else
            render json: { error: "Not successful"}, status: 400
        end
    end

    private

    def user_params
        params.permit(:email, :username, :password, :role)
    end

end
