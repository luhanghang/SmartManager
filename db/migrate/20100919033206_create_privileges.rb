class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :name
      t.timestamps
    end

    create_table :privileges_roles, :id => false do |t|
      t.references :privilege
      t.references :role
    end

    create_table :privileges_user_groups, :id => false do |t|
      t.references :privilege
      t.references :user_group
    end

    p = Privilege.new
    p.name = "设备管理"
    p.save
    
    role = Role.find_by_alias 'su'
    role.privileges << p
    
    role = Role.find_by_alias 'admin'
    role.privileges << p
    
    role = Role.find_by_alias 'mo'
    role.privileges << p

    p = Privilege.new
    p.name = "监控点分组"
    p.save

	role = Role.find_by_alias 'admin'
    role.privileges << p
    
    role = Role.find_by_alias 'su'
    role.privileges << p

    p = Privilege.new
    p.name = "电子地图"
    p.save

    p = Privilege.new
    p.name = "组织机构"
    p.save

    role = Role.find_by_alias 'su'
    role.privileges << p
    
    role = Role.find_by_alias 'mo'
    role.privileges << p

    p = Privilege.new
    p.name = "监看"
    p.save
    
    role = Role.find_by_alias 'su'
    role.privileges << p
    
    role = Role.find_by_alias 'admin'
    role.privileges << p
    
    role = Role.find_by_alias 'op'
    role.privileges << p
    
    role = Role.find_by_alias 'mo'
    role.privileges << p
    
    p = Privilege.new
    p.name = "用户管理"
    p.save
    
    role = Role.find_by_alias 'admin'
    role.privileges << p
    
    p = Privilege.new
    p.name = "设备驱动"
    p.save
    
    #role = Role.find_by_alias 'su'
    #role.privileges << p
    
    p = Privilege.new
    p.name = "当前登录用户"
    p.save

    role = Role.find_by_alias 'su'
    role.privileges << p

    role = Role.find_by_alias 'mo'
    role.privileges << p

    role = Role.find_by_alias 'admin'
    role.privileges << p

    p = Privilege.new
    p.name = "监看用户"
    p.save

    role = Role.find_by_alias 'su'
    role.privileges << p

    
    #role = Role.find_by_alias 'su'
    #role.privileges << p
    
    #p = Privilege.new
    #p.name = "信息汇总"
    #p.save
    
    #role = Role.find_by_alias 'su'
    #role.privileges << p
  end

  def self.down
    drop_table :privileges
  end
end
