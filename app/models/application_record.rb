class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  $AUTHORITY_GROUP = [["システム管理者", "superuser"], ["管理者", "admin"], ["オペレーター", "operator"], ["外部オペレーター", "outside_operator"]]
  $CHOICE_CATEGORY = [["その他", "その他"], ["施工者", "施工者"], ["調査機関", "調査機関"]]
  $HOUSE_CONSTRUCTION = [["その他", "その他"], ["鉄骨造", "鉄骨造"], ["木造", "木造"], ["RC造", "RC造"], ["SRC造", "SRC造"], ["工作物", "工作物"]]
  $HOUSE_FLOORS = [["1階建", "1階建"], ["2階建", "2階建"], ["3階建", "3階建"], ["4階建", "4階建"], ["5階建", "5階建"]]
  $SURVEY_OVERVIEW = [["概査", "概査"], ["精査", "精査"]]
  $SURVEY_TYPE = [["事前調査", "事前調査"], ["事中調査", "事中調査"], ["事後調査", "事後調査"]]
end