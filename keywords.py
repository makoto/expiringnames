import csv
import wordninja

dict = {}
count = 0
minimum = 0
ones = 0
twos = 0
more = 0
with open('data/expiringnames.csv', newline='') as csvfile:
  print(csvfile)
  spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
  for row in spamreader:
    cells = row[0].split(',')
    name = cells[0]
    date = cells[1]
    price = float(cells[2])
    words = wordninja.split(name)
    if price == 0.01 :
      minimum = minimum+1
    else:
      count = count+1

    if len(words) == 1:
      ones = ones+1
    if len(words) == 2:
      twos = twos+1
    if len(words) > 2:
      more = more+1

    for word in words:
      if word in dict:
        dict[word]['price'] = dict[word]['price'] + price
        dict[word]['count'] = dict[word]['count'] + 1
        dict[word]['names'].append(name)
      else:
        dict[word] = {'price':price, 'count':1, 'names':[name]}

sortedtuple = sorted(dict.items(), key=lambda item: item[1]['count'])
filterdtuple = [t for t in sortedtuple if len(t[0]) > 2]

bigtuple = filterdtuple[-21:-1]
bigtuple = reversed(bigtuple)
for num, d in enumerate(bigtuple, start=1):
  v = d[1]
  s = "\t"
  print(s.join([str(num), d[0], str(v['count']), format(v['price'], '.5f')]))
