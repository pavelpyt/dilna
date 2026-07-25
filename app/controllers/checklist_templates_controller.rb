class ChecklistTemplatesController < ApplicationController
  before_action :set_checklist_template, only: [ :edit, :update, :destroy ]

  def index
    authorize ChecklistTemplate
    @checklist_templates = current_account.checklist_templates.includes(:checklist_template_items).by_name
  end

  def new
    authorize ChecklistTemplate
    @checklist_template = current_account.checklist_templates.new
    3.times { @checklist_template.checklist_template_items.new }
  end

  def create
    authorize ChecklistTemplate
    @checklist_template = current_account.checklist_templates.new(checklist_template_params)

    if @checklist_template.save
      redirect_to checklist_templates_path, notice: "Šablona checklistu byla vytvořena."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @checklist_template
    3.times { @checklist_template.checklist_template_items.new }
  end

  def update
    authorize @checklist_template

    if @checklist_template.update(checklist_template_params)
      redirect_to checklist_templates_path, notice: "Šablona checklistu byla upravena."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @checklist_template
    @checklist_template.destroy
    redirect_to checklist_templates_path, notice: "Šablona checklistu byla smazána."
  end

  private

  def set_checklist_template
    @checklist_template = current_account.checklist_templates.find(params[:id])
  end

  def checklist_template_params
    params.expect(checklist_template: [
      :name,
      { checklist_template_items_attributes: [ [ :id, :label, :position, :_destroy ] ] }
    ])
  end
end
