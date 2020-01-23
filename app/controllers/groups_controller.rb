class GroupsController < ApplicationController
  #在only中的action执行的最开始执行before_action后面的方法：
  before_action:authenticate_user!,only:[:edit,:update,:new,:create,:destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

#group列表页
#=SELECT "groups".* FROM "groups"
  def index
    @groups=Group.all
  end
  #显示某一个group详情（根据id值，其包含在url中）
  #=SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ?
  def show
    @group=Group.find(params[:id])
  end
  #new和create方法成对定义：
  def new
    #new方法只是在内存中创建一个group对象，未存入数据库
    @group=Group.new
  end
  def create
    #如：@group=Group.new(:title=>"111",:description=>"222")
    @group=Group.new(group_params)
    #插入数据库的数据必须要有user_id属性
    @group.user=current_user
    #执行save，才把刚new的数据插入数据库。@group此时=插入的那一条数据（对象）
    #=INSERT INTO "groups" ("title", "description", "created_at", "updated_at", "user_id") VALUES (?, ?, ?, ?, ?)  [["title", "111"], ["description", "222"], ["created_at", "2020-01-22 16:22:38.303712"], ["updated_at", "2020-01-22 16:22:38.303712"], ["user_id", 1]]
    if @group.save
      #如果插入成功，返回列表页
      redirect_to groups_path,notice:"create success"
    else
      #继续留在新增页：
      render:new
    end
  end
#edit和update方法成对定义：
  def edit
  end
  def update
    #update需要有title和description字段值,作为参数，在最后定义了。
    #如果更新(编辑)成功，返回列表页
    if @group.update(group_params)
      redirect_to groups_path,notice:"update success"
    else
      #继续留在编辑页：
      render:edit
    end
  end


  def destroy
    #删除某一条指定数据（根据id）
    #=DELETE FROM "groups" WHERE "groups"."id" = ?  [["id", 15]]
    @group.destroy
    #不能用notice，notice都是绿色的：
    flash[:alert]="delete success"
    redirect_to groups_path
  end

  private
  def find_group_and_check_permission
    #
    @group=Group.find(params[:id])
    if current_user!=@group.user
      redirect_to root_path,alert:"你没有权限"
    end
  end
  def group_params
    params.require(:group).permit(:title,:description)
  end

end
