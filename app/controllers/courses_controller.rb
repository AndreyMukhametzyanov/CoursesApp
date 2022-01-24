class CoursesController < ApplicationController
    def index
        @courses = Course.all
    end
    
    def new 

    end

    def create
        
    end

    def show
        @course = Course.find_by_id(params[:id])
    end

    def edit
        
    end

    def destroy

    end
end