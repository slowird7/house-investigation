# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

############### サーバー起動直前に実施 ###############
# 参考）https://qiita.com/qpSHiNqp/items/254ff427bc1487e082bc
user=User.find_by(email: 'eishi.asao@bicyear.net')
if user.blank?
  user = User.new(role: 'superuser', email: 'eishi.asao@bicyear.net', password: 'yousei0930')
  user.save
end

user=User.find_by(email: 't-tanaka@kinsoku.com')
if user.blank?
  user = User.new(role: 'admin', email: 't-tanaka@kinsoku.com', password: 'password')
  user.save
end

user=User.find_by(email: 'h_tsubokura@kinsoku.net')
if user.blank?
  user = User.new(role: 'operator', email: 'h_tsubokura@kinsoku.net', password: 'password')
  user.save
end

user=User.find_by(email: 'k_fujita@kinsoku.net')
if user.blank?
  user = User.new(role: 'operator', email: 'k_fujita@kinsoku.net', password: 'password')
  user.save
end

run Rails.application
