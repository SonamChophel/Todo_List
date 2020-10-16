class ListsController < ApplicationController
    before_action :find_list, only: [:update, :destroy]
    

    def show_all
        if role
            @lists = List.all
            render json: @lists
        else
            render json: { message: "Unauthorized access"}, status:401
        end
    end

    def show
        @lists = List.where(user_id: params[:user_id])
        render json: @lists
    end

    def create
        params[:user_id] = params[:user_id]
        @list = List.new(list_params)
        if @list.save 
            render json:  @list 
        else
            render error: { error: 'Unable to create list'}, status: 400
        end
    end

    def update
        if @list
            @list.update(list_params)
            render json: { message: 'List updated successfully'}, status: 200
        else
            render json: { error: 'Unable to update the list'}, status: 400
        end
    end

    def destroy
        if @list
            @list.destroy
            render json: {message: 'List deleted successfully'}, status: 200
        else
            render json: { error: 'Unable to delete the list'}, status: 400
        end   
    end
    
    def completed_list
        @list = List.where(isComplete: true)
        render json: @list        
    end

    def incomplete_list
        @list = List.where(isComplete: false)
        render json: @list        
    end    

    private 
    def list_params
        params.permit(:title, :description, :isComplete, :user_id)
    end

    def find_list
        @list = List.find(params[:list_id])
    end
end
