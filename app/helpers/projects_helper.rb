module ProjectsHelper

	def custom_item_rows(custom_items, deletebtn)
		output = ""
		custom_items.each do |ci|
			if ci.remark == "" 
				remark = link_to "add remark", user_project_category_customitem_addremark_path(current_user, ci.project, ci.category, ci), class: "addremark" if deletebtn
			else 
				remark = "<span class=\"glyphicon glyphicon-exclamation-sign\"></span> #{ci.remark} <div class=\"addremark\">#{link_to "edit", user_project_category_customitem_editremark_path(current_user, ci.project, ci.category, ci) if deletebtn}#{ " | " if deletebtn}#{link_to "delete", user_project_category_customitem_destroyremark_path(current_user, ci.project, ci.category, ci), method: "delete" if deletebtn}</div>"
			end
			output += "<tr><td><strong>#{ci.quantity}</strong> x</td><td><strong>#{ci.name} #{link_to "Edit", edit_user_project_category_customitem_path(current_user, ci.project, ci.category, ci), class: "editcustomitem" if deletebtn}</strong>#{ci.included_acc == "" ? "" : "<p style=\"margin-bottom: 0;\"><strong><em>With:</em></strong>#{ci.included_acc}</p>"}</td><td class=\"remarktab\">#{remark}</td>#{ if deletebtn then "<td>#{ link_to raw("<span class=\"glyphicon glyphicon-remove\"></span>"), user_project_category_customitem_path(current_user, ci.project, ci.category, ci), class: "btn-delete", method: "delete" }</td>" end }</tr>".html_safe
		end
		output.html_safe
	end

	def display_product_table_of_category(category, project, link_to_categories, deletebtn)
		if category.parent_id.nil?
			if link_to_categories
				output = "<div class=\"panel-body\"><h2><a href=\"#{add_user_project_path(current_user, project)}/#{category.id}\">Additional #{category.name}</a></h2><table class=\"table table-hover top-margin-20\"><tbody>".html_safe
			else
				output = "<div class=\"panel-body\"><h2>Additional #{category.name}</h2><table class=\"table table-hover top-margin-20\"><tbody>".html_safe
			end
		else
			if link_to_categories
#				add_user_project_path(current_user, project) + "/#{category.id}"
				output = "<div class=\"panel-body\"><h2><a href=\"#{add_user_project_path(current_user, project)}/#{category.id}\">#{category.name}</a></h2><table class=\"table table-hover top-margin-20\"><tbody>".html_safe
			else
				output = "<div class=\"panel-body\"><h2>#{category.name}</h2><table class=\"table table-hover top-margin-20\"><tbody>".html_safe
			end
		end
		rowcount =  0
		# for each prduct in category
		category.products.order("name ASC").each do |p|
			ap = p.assigned_products.where("project_id = ?", project.id).first
			# if product belongs to project render row
			if not p.projects.where("project_id = ?", project.id).first.nil?
				rowcount += 1
				output += "
				<tr>
					<td class=\"text-right bang-nowrap\">
						<strong>".html_safe + ap.quantity.to_s + "</strong> x
					</td>
					<td style=\"width: 50%;\">
						<strong> #{p.name}</strong>".html_safe
				if p.included_acc != ""
					output += "
					<p style=\"margin-bottom: 0;\"><em><strong>With:</strong></em> #{p.included_acc}</p>".html_safe
				end
				if ap.remarks.nil?
					# render "add remark" on hover row
					output += "</td><td class=\"bang-nowrap\" style=\"width: 50%; text-align: right;\">#{link_to "add remark", user_project_path(current_user, project) + "/newremark/" + p.id.to_s, class: "addremark" unless deletebtn == false}".html_safe
				else
					#render remarks
					if deletebtn
						# render with "edit | delete" Buttons
						output += "</td><td class=\"remarktab\" style=\"width: 50%;\"><span class=\"glyphicon glyphicon-exclamation-sign\"></span> #{ap.remarks} <div class=\"addremark\">#{link_to "edit", user_project_path(current_user, project) + "/remark/" + p.id.to_s + "/edit"} | #{link_to "delete", user_project_path(current_user, project) + "/deleteremark/" + p.id.to_s, method: "delete" }</div>".html_safe
					else
						# render plain remark Text
						output += "</td><td class=\"remarktab\" style=\"width: 50%;\"><span class=\"glyphicon glyphicon-exclamation-sign\"></span> #{ap.remarks}".html_safe
					end
				end
				if deletebtn
					# render delete Btn if wanted
					output += "</td><td>#{link_to raw('<span class="glyphicon glyphicon-remove"></span>'), user_project_path(current_user, project) + "/delete/#{p.id}", class: 'btn-delete', method: 'delete'}".html_safe
				end
				# Close Row
				output += "</td></tr>".html_safe
			end
		end
		# Add Custom Items Rows:
		output += custom_item_rows( project.custom_items.where("category_id = ?", category.id).order("created_at ASC"), deletebtn )
		if rowcount == 0
			output = ""
		else
			# render "Add Custom Stuff"
			if deletebtn
				output += "</td></tr><tr><td></td><td colspan=\"3\">#{link_to raw("<span class=\"glyphicon glyphicon-plus\"></span> Add Custom Item"), new_user_project_category_customitem_path(current_user, project, category) }".html_safe
			end

			output += "</tbody></table></div>".html_safe
		end
		output.html_safe
	end

	def display_products_or_sub_category_of_project(category, project, link_to_categories, deletebtn)
		tree = ""
		if category.subcategories.count > 0
			category.subcategories.order("name ASC").each do |subc|
				# Sub-Category detected
				# display_product_or_sub_categrie for each subc
				tree += "#{display_products_or_sub_category_of_project(subc, project, link_to_categories, deletebtn)}".html_safe
			end
		else
			# No Sub-Categories
			# display products If any
			tree += display_product_table_of_category(category, project, link_to_categories, deletebtn) if category.products.count > 0
		end
		tree.html_safe
	end

	def active_category?(category, current_category)
		if category == current_category
			active = " class=\"active\""
		else
			active = ""
		end
		active
	end

	def display_tree(category, current_category, depth)
		tree = ""
		if category.parent_id.nil?
			tree = "<li#{active_category?(category, current_category)}><strong><a href=\"#{add_user_project_path(current_user, @project)}/#{category.id.to_s}\" class=\"top-padding-20\">#{category.name}</a></strong></li>"
		else
#			if category.products.count > 0 || category.subcategories.count > 0
# is disabled				# Render Category or Sub-Categories only if they have any
				if category.subcategories.count > 0
					# bold
					tree = "<li#{active_category?(category, current_category)}><strong><a href=\"#{add_user_project_path(current_user, @project)}/#{category.id.to_s}\" style=\"padding-left: #{depth*20}px;\">#{category.name}</a></strong></li>"
				else
					# normal
					tree = "<li#{active_category?(category, current_category)}><a href=\"#{add_user_project_path(current_user, @project)}/#{category.id.to_s}\" style=\"padding-left: #{depth*20}px;\">#{category.name}</a></li>"
				end
#			end
		end
		if category.subcategories.count > 0
			category.subcategories.order("name ASC").each do |subc|
				tree += "#{display_tree(subc, current_category, depth+1)}"
			end
		end
		tree.html_safe
	end

end
