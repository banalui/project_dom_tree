require "tree_searcher"

describe TreeSearcher do

	describe 'load file' do

		let (:tree_searcher) {TreeSearcher.new("test.html")}

		it 'properly find all classes list-item' do
			list_items = tree_searcher.search_by(:class, "list-item")
			expect(list_items).to be_a_kind_of(Array)
			expect(list_items.size).to eq(2)
		end

		it 'properly find id main-area sidebar' do
			ids = tree_searcher.search_by(:id, "main-area")
			expect(ids).to be_a_kind_of(Array)
			expect(ids.size).to eq(1)
			expect(ids[0].type).to eq("main")
		end

		it 'properly finds all li items' do
			lis = tree_searcher.search_by(:text, "li")
			expect(lis).to be_a_kind_of(Array)
			expect(lis.size).to eq(13)
		end

		it 'properly finds name' do
			names = tree_searcher.search_by(:name, "funny")
			expect(names).to be_a_kind_of(Array)
			expect(names.size).to eq(1)
			expect(names[0].type).to eq("li")
		end

		it 'properly finds name for children1' do
			names = tree_searcher.search_by(:name, "fun")
			expect(names).to be_a_kind_of(Array)
			expect(names.size).to eq(2)
			expect(names[0].type).to eq("div")
		end

		it 'properly finds name for children2' do
			ids = tree_searcher.search_by(:id, "main-area")
			main_tag = ids[0]
			expect(main_tag.type).to eq("main")
			names = tree_searcher.search_children(main_tag, :name, "fun")
			expect(names).to be_a_kind_of(Array)
			expect(names.size).to eq(1)
			expect(names[0].type).to eq("li")
		end

		it 'properly search ancestors of a node' do
			ids = tree_searcher.search_by(:name, "funny")
			main_tag = ids[0]
			divs = tree_searcher.search_ancestors(main_tag, :text, "main")
			expect(divs).to be_a_kind_of(Array)
			expect(divs.size).to eq(1)
			expect(divs[0].type).to eq("main")
		end
	end
end
