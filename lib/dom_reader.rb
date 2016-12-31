require_relative 'stack'

Tag = Struct.new(:type, :classes, :id, :name, :parent, :children, :simple_text, :content, :depth)

class DOMReader

	def build_tree(path_to_file)
		html_string = HtmlLoader.load_html_file(path_to_file)
		parser_script(html_string)
	end

	def parse_tag(tag_line)
		tag = Tag.new(nil, nil, nil, nil, nil, [], false, nil, 0)
		regex_tag_type = /<(.*?)[\s>]/
		matches = tag_line.match(regex_tag_type)
		tag.type = matches.captures[0]
		regex_classes = /class='(.*?)'/
		matches = tag_line.match(regex_classes)
		tag.classes = matches.captures[0].split unless matches.nil?
		regex_id = /id='(.*?)'/
		matches = tag_line.match(regex_id)
		tag.id = matches.captures[0] unless matches.nil?
		regex_name = /name='(.*?)'/
		matches = tag_line.match(regex_name)
		tag.name = matches.captures[0] unless matches.nil?
		tag
	end

	def find_next_content(node_content)
		work_string = []
		regex_next_content_finder = /(.*?)</
		caught_content = node_content.match(regex_next_content_finder).captures[0] unless node_content.match(regex_next_content_finder).nil?
		if caught_content == ""
			regex_next_content_finder = /(<.*?>)/
			caught_content = node_content.match(regex_next_content_finder).captures[0]
			regex_remaining_content_finder = /<.*?>(.*)/
			remaining_content = node_content.match(regex_remaining_content_finder).captures[0]
		else
			regex_remaining_content_finder = /(<.*)/
			remaining_content = node_content.match(regex_remaining_content_finder).captures[0]
		end
		work_string[0] = caught_content
		work_string[1] = remaining_content
		work_string
	end

	def parser_script(html)
		parents_stack = Stack.new
		current_html = html
		root = nil
		loop do
			current_parent = parents_stack.peek
			work_string = find_next_content(current_html)
			if is_close_tag?(work_string[0])
				parents_stack.pop
			else
				if is_text?(work_string[0])
					tag = Tag.new(nil, nil, nil, nil, nil, [], true, work_string[0], 0)
				else
					tag = parse_tag(work_string[0])
					parents_stack.push(tag)
				end
				if root.nil?
					root = tag
				end
				if current_parent.nil?
					current_parent = tag
				else
					current_parent.children[current_parent.children.size] = tag
					tag.parent = current_parent
					tag.depth = tag.parent.depth + 1
				end
			end
			current_html = work_string[1]
			break if current_html.nil? || current_html == ""
		end
		root
	end

	def is_close_tag?(tag)
		(tag[0..1] == "</")
	end

	def is_text?(content)
		content[0] != "<" 
	end

end
