class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :alias
      t.timestamps
    end

    role = Role.new
    role.name = "超级用户"
    role.alias = "su"
    role.save

    role = Role.new
    role.name = "管理员"
    role.alias = "admin"
    role.save

    role = Role.new
    role.name = "监看用户"
    role.alias = "op"
    role.save

    role = Role.new
    role.name = "系统监看员"
    role.alias = "mo"
    role.save

    create_table :users do |t|
      t.string :account
      t.string :passwd
      t.string :realname
      t.references :user_group, :default => 0
      t.references :company
      t.timestamps
    end

    create_table :user_groups do |t|
      t.string :name
      t.references :role
      t.references :company
      t.timestamps
    end

    create_table :spots_user_groups, :id => false do |t|
      t.references :spot
      t.references :user_group
    end

    group = UserGroup.new
    group.name = "超级用户"
    group.role_id = 1;
    group.save

    group = UserGroup.new
    group.name = "系统监看员"
    group.role_id = 4;
    group.save

    user = User.new
    user.account = "su"
    user.passwd = "su"
    user.realname = "超级用户"
    user.user_group_id = 1
    user.save
    
  end

  def self.down
    drop_table :users
    drop_table :user_groups
    drop_table :roles
  end
end
