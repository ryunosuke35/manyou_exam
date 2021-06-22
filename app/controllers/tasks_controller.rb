class TasksController < ApplicationController

  def index
    if params[:sort_deadline].present?
      @task = current_user.tasks.deadline
    elsif params[:sort_priority].present?
      @task = current_user.tasks.priority
    elsif params[:ambiguous].present? && params[:status].present?
      @task = current_user.tasks.ambiguous(params[:ambiguous]).status(params[:status])
    elsif params[:ambiguous].present?
      @task = current_user.tasks.ambiguous(params[:ambiguous])
    elsif params[:status].present?
      @task = current_user.tasks.status(params[:status])
    elsif params[:label_id].present?
      @task = current_user.tasks.joins(:labels).where(labels: { id: params[:label_id] })
    else
      @task = current_user.tasks.created_at
    end
    @task = @task.page(params[:page]).per(8)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to @task, notice: "登録が完了しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "編集が完了しました！"
    else
      render :edit
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "削除が完了しました！"
  end





  private
  def task_params
    @task = params.require(:task).permit(:title, :content, :deadline, :status, :priority, label_ids: [])
  end

end




# .permit(:task, { ids: [] }
