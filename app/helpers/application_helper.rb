module ApplicationHelper
  def disp_user_role(role)
    if role == "superuser"
      return "システム管理者"
    elsif role == "admin"
      return "管理者"
    elsif role == "operator"
      return "オペレーター"
    elsif role == "outside_operator"
      return "外部オペレーター"
    else
      return "unknown"
    end
  end
end
