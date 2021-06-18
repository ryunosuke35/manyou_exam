class TasksController < ApplicationController

  def index
    if params[:sort_deadline].present?
      @task = Task.all.deadline
    elsif params[:sort_priority].present?
      @task = Task.priority
    elsif params[:ambiguous].present? && params[:status].present?
      @task = Task.ambiguous(params[:ambiguous]).status(params[:status])
    elsif params[:ambiguous].present?
      @task = Task.ambiguous(params[:ambiguous])
    elsif params[:status].present?
      @task = Task.status(params[:status])
    else
      @task = Task.all.created_at
    end
    @task = @task.page(params[:page]).per(5)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
    @task = params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

end
