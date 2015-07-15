# encoding: utf-8
urkel = Cv.find(19)

[["Patrik McKiernan", "patrikmc@kth.se", "D-05", "070-4964282", "1983"],
["Pontus Walter", "pwalter@kth.se", "D-05", "073-0476125", "1986"],
["Felix Wallén", "felixw@kth.se", "D-05", "073-7287011", "1986"],
["Elin Rydberg", "erydberg@kth.se", "D-05", "073-8158634", "1987"],
["Gustaf Carleson", "gustafca@kth.se", "D-03", "076-2736650", "1980"],
["Jonas Hellgren", "jhellg@kth.se", "D-05", "070-0375390", "1983"],
["Daniel Öberg", "danielob@kth.se", "D-05", "073-3746905", "1986"],
["Henrik Sandström", "hsandst@kth.se", "D-05", "073-7676833", "1986"],
["Johan Gustafson", "johgusta@kth.se", "D-05", "070-3743640", "1986"],
["Per Almqvist", "peralmq@kth.se", "D-05", "070-7778536", "1982"],
["Alexander Kjellén", "akjellen@kth.se", "D-05", "070-3793143", "1985"],
["Daniel Walz", "walz@kth.se", "D-05", "070-3931204", "1985"],
["Per Frost", "pfrost@kth.se", "D-05", "073-9515097", "1985"],
["Joel Palmert", "palmert@kth.se", "D-04", "073-5744333", "1985"],
["Daniel Andersson Tenninge", "danielat@kth.se", "D-05", "070-4425633", "1985"],
["Simon Stenström", "ssimon@kth.se", "D-05", "073-6163534", "1986"],
["Johannes Svensson", "johsv@kth.se", "D-05", "070-6458325", "1986"],
["Misael Berrios Salas", "mjbs@kth.se", "D-05", "070-4333005", "1986"],
["Christoffer Lundell Johansson", "chlj@kth.se", "D-05", "073-6377028", "1986"],
["Fredrik Vretblad", "fvre@kth.se", "D-05", "073-5833912", "1986"],
["Victor Mangs", "vmangs@kth.se", "D-05", "070-4478544", "1986"],
["Erik Skogby", "skogby@kth.se", "D-05", "070-8655408", "1986"],
["Erik Nordenhök", "nordenh@kth.se", "D-05", "070-4999539", "1986"],
["Olof Ol-Mårs", "olofom@kth.se", "D-05", "070-2880491", "1986"],
["Jan-Erik Bredahl", "bredahl@kth.se", "D-05", "073-6481610", "1986"],
["Joakim Ekberg", "jekb@kth.se", "D-05", "070-7480757", "1985"],
["Johannes Edelstam", "jede@kth.se", "D-05", "073-5011021", "1986"],
["Per-Anders Legeryd", "legeryd@kth.se", "D-04", "073-9057899", "1982"],
["Max Walter", "maxwa@kth.se", "D-04", "073-0476116", "1984"],
["Kristoffer Renholm", "renholm@kth.se", "D-05", "070-2361751", "1986"]].each do |user_array|
  cv = Cv.new
  
  cv.attributes = urkel.attributes.clone
  
  cv.name = user_array[0]
  cv.mail = user_array[1]
  cv.phone = user_array[3]
  cv.birth_year = user_array[4]
  
  puts cv.name
  puts cv.ambitions

  cv.save
end
