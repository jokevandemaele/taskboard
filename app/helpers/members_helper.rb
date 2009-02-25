module MembersHelper
  def select_tag_for_nametag_color(name)
    colors = Array.new
    color= Array.new
    1.upto(41) do  |number| 
	colors << [number,number]
    end
    return select_tag name, "#{options_for_select(colors)}"
  end
end
