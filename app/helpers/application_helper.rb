module ApplicationHelper

	def nav_link(link_text, controller_name)

		if controller.controller_name == controller_name then
			link_to link_text, url_for(:controller => controller_name), :class => 'active'
		else
			link_to link_text, url_for(:controller => controller_name)
		end
	end

end
