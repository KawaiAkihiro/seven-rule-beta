class SessionsController < ApplicationController
    def new
    end
  
    #ログイン処理
    def create
      master = Master.find_by(store_name: params[:session][:store_name])
      if master &.authenticate(params[:session][:password])
        log_in master
        params[:session][:remember_me] == '1' ? remember(master): forget(master)
        redirect_to root_url
      else
        flash.now[:danger] = '店舗名,またはパスワードが間違っています。'
        render 'new'
      end
    end
  
    #ログアウト処理
    def destroy
      log_out if logged_in?
      redirect_to root_url
    end
end
