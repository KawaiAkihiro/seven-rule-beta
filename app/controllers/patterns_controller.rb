class PatternsController < ApplicationController
    before_action :logged_in_staff
    def index
        @patterns = current_staff.patterns.all
    end

    def destroy
        @pattern = current_staff.patterns.find(params[:id]).destroy
        redirect_to patterns_path
    end
end

