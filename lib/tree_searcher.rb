require_relative 'dom_reader'
require_relative 'queue'


class TreeSearcher

	attr_accessor :root

	def initialize(a_file_path)
		dom_reader = DOMReader.new
		@root = dom_reader.build_tree(a_file_path)
	end

	def search_ancestors(node, attribute_type, attribute_value)
		result_nodes = []
		cur_node = node
		until cur_node.parent.nil?
			cur_node = cur_node.parent
			case attribute_type
			when :class
				result_nodes << cur_node if cur_node.classes && cur_node.classes.include?(attribute_value)
			when :name
				result_nodes << cur_node if cur_node.name == attribute_value
			when :id
				result_nodes << cur_node if cur_node.id == attribute_value
			when :text
				result_nodes << cur_node if cur_node.type == attribute_value
			end
		end
		result_nodes
	end

	def search_children(node, attribute_type, attribute_value)
		result_nodes = []
		node.children.each do |child|
			bfs(child, attribute_type, attribute_value, result_nodes)
		end
		result_nodes
	end

	def search_by(attribute_type, attribute_value)
		result_nodes = []
		bfs(@root, attribute_type, attribute_value,result_nodes)
		result_nodes
	end

	def bfs(root, attribute_type, attribute_value, result_nodes)
		bfs_traverse_q = Queue.new
		bfs_traverse_q.enqueue(root)
		loop do
			cur_node = bfs_traverse_q.dequeue
			case attribute_type
			when :class
				result_nodes << cur_node if cur_node.classes && cur_node.classes.include?(attribute_value)
			when :name
				result_nodes << cur_node if cur_node.name == attribute_value
			when :id
				result_nodes << cur_node if cur_node.id == attribute_value
			when :text
				result_nodes << cur_node if cur_node.type == attribute_value
			end
			cur_node.children.each do |child|
				bfs_traverse_q.enqueue(child)
			end
			break if bfs_traverse_q.empty?
		end
	end
end

#tree_searcher = TreeSearcher.new("test.html")
#tree_searcher.search_by(:class, "sidebar")

#sidebars = searcher.search_by(:class, "sidebar")
#sidebars.each { |node| renderer.render(node) }
# ...output for all nodes...