class TasksController < ApplicationController

  def index
    if params[:sort_expired].present?
      @task = Task.all.deadline
    elsif params[:ambiguous].present? && params[:priority].present?
      @task = Task.ambiguous(params[:ambiguous]).priority(params[:priority])
    elsif params[:ambiguous].present?
      @task = Task.ambiguous(params[:ambiguous])
    elsif params[:priority].present?
      @task = Task.priority(params[:priority])
    else
      @task = Task.all.created_at
    end
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
    @task = params.require(:task).permit(:title, :content, :deadline, :priority)
  end

end
