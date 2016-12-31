require_relative 'html_loader'
require_relative 'queue'
require_relative 'dom_reader'

class Renderer

	def initialize(a_file_path)
		dom_reader = DOMReader.new
		@root = dom_reader.build_tree(a_file_path)
	end

	def output_html
		render_html(@root)
	end

	def bfs_traverse(node)
		bfs_traverse_q = Queue.new
		bfs_traverse_q.enqueue(node)
		total_nodes = 0
		node_types = Hash.new(0)
		result = []
		loop do
			cur_node = bfs_traverse_q.dequeue
			total_nodes += 1
			if cur_node.type
				node_types[cur_node.type] += 1
			end
			cur_node.children.each do |child|
				bfs_traverse_q.enqueue(child)
			end
			break if bfs_traverse_q.empty?
		end
		result[0] = total_nodes
		result[1] = node_types
		result
	end

	def render(node)
		if node.nil?
			the_node = @root
		else
			the_node = node
		end
		return_val = bfs_traverse(the_node)
		total_nodes = return_val[0]
		node_types = return_val[1]
		puts "Node is a #{the_node.type}"
		puts "There are total #{total_nodes} nodes under this node"
		node_types.each do |key, value|
			puts "<#{key}> :: #{value}"
		end
		if the_node.classes
			the_node.classes.each do |a_class|
				puts "Node has class of #{a_class}"
			end
		end
		if the_node.id
			puts "Node has id of #{the_node.id}"
		end
		if the_node.name
			puts "Node has name of #{the_node.name}"
		end
	end

	def render_html(root)
		render_tag(root)
		root.children.each do |child|
			render_html(child)
		end
		render_closing_tag(root)
	end

	def render_closing_tag(tag)
		print " " * tag.depth * 4
		unless tag.simple_text
			puts "</#{tag.type}>"
		end
	end

	def render_tag(tag)
		print " " * tag.depth * 4
		if tag.simple_text
			puts tag.content
		else
			tag_classes_string = generate_classes_string tag
			tag_id_string = generate_id_string tag
			tag_name_string = generate_name_string tag
			puts "<#{tag.type}#{tag_classes_string}#{tag_id_string}#{tag_name_string}>"
		end
	end

	def generate_classes_string(tag)
		str = ""
		unless tag.classes.nil?
			str = " class='"
			tag.classes.each do |a_class|
				str = str + a_class
				str = str + " "
			end
			str.chop!
			str = str + "'"
		end
		
		str
	end

	def generate_id_string(tag)
		str = ""
		unless tag.id.nil?
			str = " id='#{tag.id}'"
		end
		str
	end

	def generate_name_string(tag)
		str = ""
		unless tag.name.nil?
			str = " name='#{tag.name}'"
		end
		str
	end
end

#renderer = Renderer.new("test.html")
#renderer.render(nil)
#renderer.output_html
