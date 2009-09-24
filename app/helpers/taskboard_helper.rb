module TaskboardHelper
  def taskboard_border_style(color,position)
    text = ""
    position.each do |pos|
      text << "border-#{pos}: 4px solid ##{color}; "
    end
    return text
  end
end
