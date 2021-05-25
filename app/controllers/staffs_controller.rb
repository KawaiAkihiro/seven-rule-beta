class StaffsController < ApplicationController
    before_action :logged_in_master, only: [:index, :new, :create]
    before_action :corrent_staff,   only: [:show, :edit, :update]

    def index
        @staffs = current_master.staffs.where.not(number:0).where.not(number:current_master.staff_number).page(params[:page]).per(6)
    end

    def new
        @staff = current_master.staffs.new
    end

    def create
        @staff  = current_master.staffs.new(staff_params)
        if @staff.save
            flash[:success] = "従業員登録完了しました"
            redirect_to root_url
        else
            render 'new'
        end
    end

    #未提出の従業員を抽出
    def no_submits
        @no_staffs = current_master.unsubmit_staff
    end

    def already_submits
        @no_staffs = current_master.submited_staff
    end
    
    def edit
        if logged_in?
            begin
                @staff = current_master.staffs.find(params[:id])  
            #店長の中にいないidのユーザ-のページにいこうとした時
            rescue
                redirect_to staffs_path
            end
        else
          @staff = current_staff
        end
    end  

    def update
        if logged_in?
            begin
                @staff = current_master.staffs.find(params[:id])
                if @staff.update(staff_params)
                    flash[:success] = "従業員情報を変更しました"
                    redirect_to root_path
                else
                    render 'edit'
                end
            #店長の中にいないidのユーザ-の変更を直接しようとした時
            rescue
                redirect_to root_url
            end
        else
          @staff = current_staff
          if @staff.update(staff_params)
              flash[:success] = "従業員情報を変更しました"
              redirect_to root_path
          else
              render 'edit'
          end
        end
    end

    def destroy
        current_master.staffs.find(params[:id]).destroy
        flash[:success] = "削除完了しました"
        redirect_to staffs_path
    end

    private
        def staff_params
         params.require(:staff).permit(:name, :number, :password, :password_confirmation, :training_mode)
        end
end
