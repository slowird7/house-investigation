# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user=User.find_by(user_name: 'asao')
if user.blank?
  user = User.new(role: 'superuser', user_name: 'asao', password: 'yousei0930')
  user.save
end

user=User.find_by(user_name: 'tanaka')
if user.blank?
  user = User.new(role: 'admin', user_name: 'tanaka', password: 'password')
  user.save
end

user=User.find_by(user_name: 'tsubokura')
if user.blank?
  user = User.new(role: 'admin', user_name: 'tsubokura', password: 'password')
  user.save
end

user=User.find_by(user_name: 'fujita')
if user.blank?
  user = User.new(role: 'operator', user_name: 'fujita', password: 'password')
  user.save
end

choice=Choice.find_by(name: '戸田・ハンシン特定建設共同企業体')
if choice.blank?
  choice = Choice.new(name: '戸田・ハンシン特定建設共同企業体', category: '施工者')
  choice.save
end

choice=Choice.find_by(name: '株式会社きんそく')
if choice.blank?
  choice = Choice.new(name: '株式会社きんそく', category: '調査機関')
  choice.save
end

choice=Choice.find_by(name: '株式会社きんそく家屋調査')
if choice.blank?
  choice = Choice.new(name: '株式会社きんそく家屋調査', category: '調査機関')
  choice.save
end

investigation=Investigation.find_by(construction_name: '寝屋川市秦高宮雨水幹線建設工事')
if investigation.blank?
  investigation = Investigation.new(construction_name: '寝屋川市秦高宮雨水幹線建設工事', content: "沿道家屋", 
                                    builder: "戸田・ハンシン特定建設共同企業体", investigator_pre_survey: "株式会社きんそく家屋調査", 
                                    place: "大阪府寝屋川市高宮地内")
  investigation.save
end

house= House.find_by(house_name: 'うしとら商店')
if house.blank?
  house = investigation.houses.build(house_number: 1, house_name: 'うしとら商店', prefectures: '大阪府', city: '寝屋川市高宮', block: '2-21-3',
                                    resident_phone_number: '090-1899-7408', owner_name_ruby: 'よし　ひめこ', owner_name: '良　姫子', owner_prefectures: '大阪府',
                                    owner_city: '寝屋川市明和', owner_block: '1-14-21', owner_phone_number: '072-821-4340',
                                    construction: '鉄骨造', floors: '1階建', area: '159.89', use: '倉庫')
  house.save
end