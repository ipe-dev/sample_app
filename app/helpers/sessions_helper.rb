module SessionsHelper

    # 渡されたユーザーでログインする
    def log_in(user)
        session[:user_id] = user.id
    end

    # 現在のユーザーをログアウトする
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    # セッションに保存されたユーザーを検索する
    def current_user
        
        # セッションのユーザーIDを代入し、ユーザーIDがあったら
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        
        # クッキーのユーザーIDを代入し、ユーザーIDがあったら
        elsif (user_id = cookies.signed[:user_id])
            
            user = User.find_by(id: user_id)

            # ユーザーが存在し、クッキーのremember_tokenとuserのremember_tokenが一致したら
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # ユーザーがログインしていればtrue,していなければfalseを返す
    def logged_in?
        !current_user.nil?
    end

    # ログインしたユーザーを永続的に記憶する
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # 
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
end
