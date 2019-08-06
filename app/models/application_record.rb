class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  $AUTHORITY_GROUP = [["システム管理者", "superuser"], ["管理者", "admin"], ["オペレーター", "operator"], ["外部オペレーター", "outside_operator"]]
  $CHOICE_CATEGORY = [["その他", "0"], ["施工者", "1"], ["調査機関", "2"]]  
end