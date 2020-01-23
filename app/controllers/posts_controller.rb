class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]


#show\new等这些action大部分都要操作数据库，相当于执行select\insert等命令。里面的代码可直接在rails console中执行的。
  def show
    #先找到当前访问的这个group（根据id，其在url中有）
    @group=Group.find(params[:id])
    #然后把获取其下面所有posts. group和post关联关系在models下面的xx.rb几个文件中定义，has_many或belongs_to
    #这个posts变量，直接在show.html.erb中用不了
    @posts=@group.posts
  end

  #new只是在内存中创建对象，不操作数据库
  def new
    @group=Group.find(params[:group_id])
    @post=Post.new
  end
  #create=new+save(执行sql操作数据库，所以对应表中的字段都有赋值)
  def create
    @group=Group.find(params[:group_id])
    #新建一个具体的post对象
    @post=Post.new(post_params)
    @post.group=@group
    @post.user=current_user
    #如果保存到数据库成功
    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
