class ShiftSeparationsController < ApplicationController
    before_action :logged_in_master, except: [:destroy]
    before_action :corrent_master,   except: [:destroy]

    #シフトの時間割のcrud機能

    def new
        @shift_separation = current_master.shift_separations.new
    end

    def create
        @shift_separation = current_master.shift_separations.new(separation_params)
        if @shift_separation.save 
            flash[:success] = "シフトコマを作成完了しました！"
            redirect_to root_path
        else
            render 'new'
        end
    end

    def index
        @shift_separations = current_master.shift_separations.all
    end

    def edit
        @shift_separation = current_master.shift_separations.find(params[:id])
    end

    def update
        @shift_separation = current_master.shift_separations.find(params[:id])
        if @shift_separation.update(separation_params)
            flash[:success] = "変更完了しました！"
            redirect_to master_shift_separations_path
        else
            render 'edit'
        end
    end

    def destroy
        current_master.shift_separations.find(params[:id]).destroy
        flash[:success] = "削除しました"
        redirect_to master_shift_separations_path
    end

    private 
      def separation_params
        params.require(:shift_separation).permit(:name, :start_time, :finish_time)
      end

      def corrent_master
        @master = Master.find(params[:master_id])
        redirect_to(root_url) unless current_master?(@master)
      end
end
