require('csv')
celebs = CSV.read("data/celebs.csv")

results = []
celebs.map{ |v|
  name = v[1].downcase
  name = name.split(' ').join('') if name.match(/ /)
  p name
  if name && name.length > 6
    result = `grep ^#{name}, data/expiringnames.csv`
    if result.length > 0
      bidprice = result.split(',')[2].chop
      results.push({name:name, bidprice:bidprice})
    end
  end
}
puts results.uniq.sort_by{|r| r[:bidprice].to_f }.reverse.each_with_index.map{|r,i| [i + 1, r[:name] + ".eth", r[:bidprice]].join("\t")}