require('json')
require('pp')
require('pry')
dapps = JSON.parse File.open('data/dapps.json').read
everest = JSON.parse File.open('data/everest.json').read
names = {}
r1 = dapps.map{ |k, v|
  name = v["details"]["name"].downcase.split(' ').join('')
  url = v["details"]["url"]
  unless names[name]
    names[name] = { name:name, url:url }
  end
  { name:name, url:url }
}

r2 = everest["data"]["projects"].map{ |v| 
    name = v["name"].downcase.split(' ').join('')
    url = v["website"]
    unless names[name]
      names[name] = { name:name, url:url }
    end  
    { name:name, url:url }
}

results = []
names.values.map{ |v|
  name = v[:name]
  if name.length > 6
    result = `grep ^#{name}, data/expiringnames.csv`
    p name
    p result
    if result.length > 0
      bidprice = result.split(',')[2].chop
      results.push({name:name, bidprice:bidprice})
    end
  end
}
puts results.uniq.sort_by{|r| r[:bidprice].to_f }.reverse.each_with_index.map{|r,i| [i + 1, r[:name] + ".eth", r[:bidprice]].join("\t")}