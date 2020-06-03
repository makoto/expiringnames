require('csv')
web = CSV.read("data/top500Domains.csv")

results = []
web.map{ |v| 
  url = v[1].chop
  urlname = url.split(".")[-2]
  if urlname && urlname.length > 6
    urlresult = `grep ^#{urlname}, data/expiringnames.csv`
    if urlresult.length > 0
      bidprice = urlresult.split(',')[2].chop
      results.push({name:urlname, bidprice:bidprice})
    end
  end
}
puts results.uniq.sort_by{|r| r[:bidprice].to_f }.reverse.each_with_index.map{|r,i| [i + 1, r[:name] + ".eth", r[:bidprice]].join("\t")}