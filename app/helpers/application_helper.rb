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
  
  def disp_choice_category(category)
    if category == 0
      return "その他"
    elsif category == 1
      return "施工者"
    elsif category == 2
      return "調査機関"
    else
      return "unknown"
    end
  end
end
