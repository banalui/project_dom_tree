require "dom_reader"
require "html_loader"

describe DOMReader do

	let(:a_good_path) {"test.html"}
	let(:a_bad_path) {"bad.html"}
	let(:dom_reader) {DOMReader.new}

	describe 'load file' do

		it 'properly loads a good file' do
			html_string = HtmlLoader.load_html_file(a_good_path)
			expect(html_string).to be_a_kind_of(String)
		end

		it 'properly throws error when file not present' do
			expect{HtmlLoader.load_html_file(a_bad_path)}.to raise_error("File not found")
		end

	end

	describe 'find good next items' do

		it 'properly finds tag when theres new line after it' do
			html_string = "<html>  <head>"
			result = dom_reader.find_next_content(html_string)
			expect(result[0]).to eq("<html>")
			expect(result[1]).to eq("  <head>")
		end

		it 'properly builds tree' do
			html_string = HtmlLoader.load_html_file(a_good_path)
			dom_reader.build_tree(a_good_path)
		end
	end

	describe 'parse a single tag properly' do
		it 'can parse a tag properly' do
			tag1 = dom_reader.parse_tag("<div class='top-div'>")
			expect(tag1.type).to eq("div")
			tag2 = dom_reader.parse_tag("<div >")
			expect(tag2.type).to eq("div")
		end
	end

end