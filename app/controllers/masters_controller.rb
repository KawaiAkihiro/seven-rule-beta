class MastersController < ApplicationController
  require "date" 
  before_action :logged_in_master, only: [:show, :edit, :update]
  before_action :corrent_master, only: [:show, :edit, :update]

  def new
    @master = Master.new
  end

  def create
    @master = Master.new(master_params)
    @master.submits_start = "2021-01-01"
    @master.submits_finish = "2021-01-02"
    if @master.save
      log_in @master
      
      #店長用の従業員データを作成
      create_staff(@master,@master.user_name, @master.staff_number)

      #空きシフトを作るための空従業員を作成
      create_staff(@master,"empty", 0)

      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def shift_onoff_form
    if !current_master.shift_onoff

      render plain: render_to_string(partial: "shift_period", layout: false)
    else
      render plain: render_to_string(partial: "shift_submit_finish", layout: false)
    end
  end

  #シフトを募集開始or終了する処理
  def shift_onoff   #募集開始
    if !current_master.shift_onoff

      start  = params.require(:master).permit(:start).values
      finish = params.require(:master).permit(:finish).values

      if start[0] < finish[0]
        current_master.submits_start = start[0]
        current_master.submits_finish = finish[0]

        current_master.shift_onoff = true
      else
        redirect_to root_path
        flash[:danger] = "日付設定が間違っています。もう一度登録しなおしてください"
        return
      end
    else            #募集終了
      
      @staffs = current_master.staffs.where(abandon: true)
      @staffs.each do |staff|
        staff.abandon = false
        staff.save
      end

      current_master.shift_onoff = false
    end
    
    current_master.save
    redirect_to root_url
    current_master.shift_onoff ? flash[:success] = "シフト募集を開始しました" : flash[:success] = "シフト募集を終了しました"
  end

  def edit
    @master = Master.find(params[:id])
  end

  def update
    @master = Master.find(params[:id])
    if @master.update(master_params)
      flash[:success] = "ユーザー情報を変更しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  #従業員用ログインページ
  def login_form
    @master = Master.find(params[:id])
     if logged_in_staff?
      redirect_to root_url
      flash[:success] = "現在　#{current_staff.staff_name}さん　としてログイン中です"
     end
  end
  
  #従業員用ログイン処理
  def login
    @master = Master.find(params[:id])
    @staff  = @master.staffs.find_by(staff_number: params[:staffs_session][:staff_number])  
    if @staff && @staff.authenticate(params[:staffs_session][:password])
      log_in_staff(@staff)
      redirect_to root_path
    else
      flash.now[:danger]= "従業員番号もしくはパスワードが間違っています"
      render 'login_form'
    end
  end

  #従業員用ログアウト
  def logout
    log_out_staff if logged_in_staff?
    redirect_to root_url
  end

  private
    def master_params
      params.require(:master).permit(:store_name, :user_name, :staff_number, :email, :onoff_email, :password, :password_confirmation)
    end

    def create_staff(master,name, number)
      @staff = master.staffs.new
      @staff.staff_name = name
      @staff.staff_number = number
      @staff.password = "0000"
      @staff.password_confirmation = "0000"
      @staff.save
    end
end
