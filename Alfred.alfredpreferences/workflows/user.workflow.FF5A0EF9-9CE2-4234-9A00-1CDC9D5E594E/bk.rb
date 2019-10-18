# wengwengweng

def item_xml(item = {})
    <<-ITEM
    <item arg="#{item[:path]}">
    <title>#{item[:name]}</title>
    <subtitle>#{item[:path]}</subtitle>
    </item>
    ITEM
end

def get_bookmarks()
    
    return File.read("#{ENV['HOME']}/.bookmarks").split("\n").map do |line|
        
        name = line.match(/^\[.*\]/)[0]
        path = line.match(/\(.*\)$/)[0]
        
        name = name[1..name.length - 2]
        path = path[1..path.length - 2]
        
        {
            :name => name,
            :path => path,
        }
        
    end
    
end

def get_items(pat = "")
    
    list = get_bookmarks()
    
    return list.select do |item|
        
        if pat.empty?
            true
        end
        
        item[:name].match(/#{pat}/i)
        
    end
    
end

items = get_items(ARGV[0] || "").map do |i|
    item_xml(i)
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output

