class HtmlLoader

	def self.load_html_file(path_to_file)
		html_string = ""
		unless File.file? path_to_file
			raise 'File not found'
		end
		File.open(path_to_file, 'r') do |f1|  
  			while line = f1.gets  
    			html_string += line
  			end  
		end
		html_string.gsub!(/\n/, ' ')
		html_string.gsub!(/\"/, "'")
		html_string
	end

end