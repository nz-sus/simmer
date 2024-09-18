module ApplicationHelper
  include ClientsHelper
  def flash_class(level)
    case level.to_sym
    when :notice
      'bg-blue-900 border-blue-900'
    when :success
      'bg-green-900 border-green-900'
    when :alert
      'bg-red-900 border-red-900'
    when :error
      'bg-red-900 border-red-900'
    else
      'bg-blue-900 border-blue-900'
    end
  end  
  def severities_for_select
    # use the constant from masked_secret.rb to generate a list of options for a select dropdown
    MaskedSecret::SEVERITIES.map { |k, v| [k, k] }
      
  end
  def title
    begin
      if content_for?(:title)
        # allows the title to be set in the view by using t(".title")
        content_for :title
      else
        # look up translation key based on controller path, action name and .title
        # this works identical to the built-in lazy lookup
        t("#{ controller_path.tr('/', '.') }.#{ action_name }.title", :default => "#{controller_path.humanize} - #{action_name.humanize}")
      end
    rescue
      
    end
  end
  # Helper method to create sortable links in tables
  def sortable(column, title = nil)
    # check that column is a valid column for the model referred to by the calling controller
    controller_name.classify.constantize.column_names.include?(column) || raise(ArgumentError, "Invalid column: #{column}")
    
    
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to gitleaks_results_path(sort: column, direction: direction) do
      "#{title} #{sort_icon(column, sort_column, sort_direction)}".html_safe
    end
  end

  def sort_column
    # Ensure the sorting column is one of the allowed columns
    controller_name.classify.constantize.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  def sort_icon(column, current_sort_column, current_sort_direction)
    if column == current_sort_column
      if current_sort_direction == 'asc'
        tag.svg width: "20", height: "20", class: "fill-current text-gray-500", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20" do
          tag.path fill_rule: "evenodd", d: "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z", clip_rule: "evenodd"
        end
      else
        tag.svg width: "20", height: "20", class: "fill-current text-gray-500", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20" do
          tag.path fill_rule: "evenodd", d: "M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z", clip_rule: "evenodd"
        end
      end
    else
      tag.svg width: "20", height: "20", class: "fill-current text-gray-500", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20" do
        tag.path fill_rule: "evenodd", d: "M6 10a1 1 0 011-1h6a1 1 0 110 2H7a1 1 0 01-1-1z", clip_rule: "evenodd"
      end
    end
    
  end
  
  def filter_color_class(key)
    case key
    when 'severity'
      'bg-red-100 text-red-800'
    when 'rule_id'
      'bg-green-100 text-green-800'
    when 'commit'
      'bg-yellow-100 text-yellow-800'
    when 'file'
      'bg-purple-100 text-purple-800'
    else
      'bg-blue-100 text-blue-800'
    end
  end
  
  private

end
