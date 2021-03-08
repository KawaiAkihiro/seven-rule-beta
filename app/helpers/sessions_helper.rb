module SessionsHelper
    def log_in(master)
        session[:master_id] = master.id
    end

    def current_master
        if(master_id=session[:master_id])
            @current_master ||= Master.find_by(id:master_id)
        elsif(master_id=cookies.signed[:master_id])
            master = Master.find_by(id:master_id)
            if master &. authenticated?(cookies[:remember_token])
                log_in master
                @current_master = master
            end
        end
    end

    def current_master?(master)
        master && master == current_master
    end

    def logged_in?
        !current_master.nil?
    end

    def remember(master)
        master.remember
        cookies.permanent.signed[:master_id] = master.id
        cookies.permanent[:remember_token] =   master.remember_token
    end

    def forget(master)
        master.forget
        cookies.delete(:master_id)
        cookies.delete(:remember_token)
    end

    def log_out
        forget(current_master)
        session.delete(:master_id)
        @current_master = nil
    end
end
