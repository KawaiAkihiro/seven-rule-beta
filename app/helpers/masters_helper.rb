module MastersHelper
    def logged_in_master
        unless logged_in?
          flash[:danger] = "ログインしてください"
          redirect_to login_url
        end
    end

    def corrent_master
      @master = Master.find(params[:id])
      redirect_to(root_url) unless current_master?(@master)
    end 

    #以下 staff モデルに関するもの

    def log_in_staff(staff)
      session[:staff_id] = staff.id
    end

  def current_staff
      if(staff_id=session[:staff_id])
          @current_staff ||= Staff.find_by(id:staff_id)
      end
  end

  def current_staff?(staff)
      staff && staff == current_staff
  end

  def log_out_staff
      session.delete(:staff_id)
      @current_staff = nil
  end

  def logged_in_staff?
     !current_staff.nil?
  end

  def logged_in_staff
    unless logged_in_staff?
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
  end

  def corrent_staff
    unless logged_in? 
        unless logged_in_staff?
            flash[:danger] = "ログインしてください"
            redirect_to staffs_login_url
        else
            begin
                @master = Master.find(current_staff.master_id)
                @other_staff = @master.staffs.find(params[:id])
                unless current_staff?(@other_staff) 
                    flash[:danger] = "他のユーザの情報は見ることができません"
                    redirect_to(current_staff) 
                end
            rescue
                redirect_to current_staff
            end  
        end
    end
  end

end
