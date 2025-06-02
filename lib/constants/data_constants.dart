final List<String> provinces = ["Ilocos Norte", "Ilocos Sur", "La Union", "Pangasinan",
    "Batanes", "Cagayan", "Isabela", "Nueva Vizcaya", "Quirino",
    "Aurora", "Bataan", "Bulacan", "Nueva Ecija", "Pampanga", "Tarlac", "Zambales",
    "Batangas", "Cavite", "Laguna", "Quezon", "Rizal",
    "Marinduque", "Occidental Mindoro", "Oriental Mindoro", "Palawan", "Romblon",
    "Albay", "Camarines Norte", "Camarines Sur", "Catanduanes", "Masbate", "Sorsogon",
    "Abra", "Apayao", "Benguet", "Ifugao", "Kalinga", "Mountain Province",
    "Aklan", "Antique", "Capiz", "Guimaras", "Iloilo", "Negros Occidental",
    "Bohol", "Cebu", "Negros Oriental", "Siquijor",
    "Biliran", "Eastern Samar", "Leyte", "Northern Samar", "Samar", "Southern Leyte",
    "Zamboanga del Norte", "Zamboanga del Sur", "Zamboanga Sibugay",
    "Bukidnon", "Camiguin", "Lanao del Norte", "Misamis Occidental", "Misamis Oriental",
    "Davao de Oro", "Davao del Norte", "Davao del Sur", "Davao Oriental", "Davao Occidental",
    "Cotabato", "Sarangani", "Sultan Kudarat", "South Cotabato", "General Santos City",
    "Basilan", "Lanao del Sur", "Maguindanao", "Sulu", "Tawi-Tawi",
    "Agusan del Norte", "Agusan del Sur", "Butuan City", "Surigao del Norte", "Surigao del Sur"];

final Map<String, List<String>> provinceCities = {
  // Luzon
  "Ilocos Norte": [
    "Laoag City", "Batac City", "Paoay", "Pagudpud", "Dingras", "Vintar", "Sarrat", 
    "Bacarra", "San Nicolas", "Pasuquin", "Badoc", "Laoag City"
  ],
  "Ilocos Sur": [
    "Vigan City", "Candon City", "Suyo", "Cervantes", "Sinait", "Tagudin", "Cabugao", 
    "San Juan", "Galimuyod", "Quirino", "Bantay"
  ],
  "La Union": [
    "San Fernando City", "Agoo", "Bauang", "Naguilian", "Rosario", "San Juan", 
    "Santol", "Bagulin", "Sudipen", "Pugo", "San Gabriel"
  ],
  "Pangasinan": [
    "Lingayen", "Dagupan City", "Urdaneta City", "Alaminos City", "Bayambang", 
    "San Carlos City", "San Fernando", "Manaoag", "Malasiqui", "Urduja"
  ],
  "Batanes": [
    "Basco", "Itbayat", "Ivana", "Sabtang", "Uyugan"
  ],
  "Cagayan": [
    "Tuguegarao City", "Aparri", "Ilagan", "Santiago City", "Lasam", "Peñablanca", 
    "Gattaran", "Piat", "Amulung", "Solana"
  ],
  "Isabela": [
    "Ilagan City", "Santiago City", "Cauayan City", "Alicia", "Gamu", "Roxas", 
    "Benito Soliven", "Jones", "San Mariano", "Tumauini"
  ],
  "Nueva Vizcaya": [
    "Bayombong", "Solano", "Aritao", "Dupax del Norte", "Dupax del Sur", "Kasibu", 
    "Bagabag", "Villaverde", "Quezon", "Ambaguio"
  ],
  "Quirino": [
    "Cabarroguis", "Diffun", "Nagtipunan", "Saguday", "Aglipay", "Maddela", 
    "Culianan", "Nagtipunan", "Santiago", "Anduyan"
  ],
  "Aurora": [
    "Baler", "Casiguran", "Dipaculao", "Maria Aurora", "San Luis", "San Nicolas", 
    "Dinalungan", "Dingalan", "Bongabon", "San Jose"
  ],
  "Bataan": [
    "Balanga City", "Orani", "Dinalupihan", "Limay", "Mariveles", "Hermosa", 
    "Abucay", "Samal", "Morong", "Orion"
  ],
  "Bulacan": [
    "Malolos City", "Meycauayan City", "San Jose del Monte City", "Baliuag", 
    "Santa Maria", "San Ildefonso", "San Rafael", "Hagonoy", "Marilao", "Pandi"
  ],
  "Nueva Ecija": [
    "Palayan City", "Cabanatuan City", "Gapan City", "San Jose City", "Carranglan", 
    "Nampicuan", "Bongabon", "General Tinio", "Santa Rosa", "Rizal"
  ],
  "Pampanga": [
    "San Fernando City", "Angeles City", "Mabalacat City", "Mexico", "Guagua", 
    "Apalit", "Bacolor", "Lubao", "Sasmuan", "San Simon"
  ],
  "Tarlac": [
    "Tarlac City", "Paniqui", "Concepcion", "La Paz", "San Jose", "Capas", 
    "Mayantoc", "San Manuel", "Ramos", "San Clemente"
  ],
  "Zambales": [
    "Iba", "Olongapo City", "Masinloc", "Subic", "Castillejos", "San Antonio", 
    "San Narciso", "San Marcelino", "San Felipe", "Botolan"
  ],
  "Batangas": [
    "Batangas City", "Lipa City", "Tanauan City", "Nasugbu", "Taal", "Balayan", 
    "San Jose", "Lian", "San Pascual", "Calaca"
  ],
  "Cavite": [
    "Kawit", "Imus City", "Dasmariñas City", "Tagaytay", "Silang", "Gen. Trias", 
    "Bacoor", "Tanza", "Naic", "Maragondon"
  ],
  "Laguna": [
    "Santa Cruz", "San Pablo City", "Biñan City", "Santa Rosa City", "Calamba City", 
    "Los Baños", "Nagcarlan", "Alaminos", "Victoria", "Pagsanjan"
  ],
  "Quezon": [
    "Lucena City", "Tayabas City", "Mauban", "Sariaya", "Candelaria", 
    "Bondoc Peninsula", "Guinyangan", "San Antonio", "Tiaong", "Jomalig"
  ],
  "Rizal": [
    "Antipolo City", "Cainta", "Angono", "Binangonan", "Taytay", "Rodriguez", 
    "Jala-Jala", "Baras", "San Mateo", "Morong"
  ],
  "Marinduque": [
    "Boac", "Mogpog", "Santa Cruz", "Gasan", "Buenavista", "Torrijos", "Seria"
  ],
  "Occidental Mindoro": [
    "Mamburao", "San Jose", "Calintaan", "Sablayan", "Rizal", "Paluan", "Lubang"
  ],
  "Oriental Mindoro": [
    "Calapan City", "Puerto Galera", "San Teodoro", "Baco", "Roxas", "Bansud", 
    "Pinamalayan", "Pola", "Naujan", "Victoria"
  ],
  "Palawan": [
    "Puerto Princesa City", "El Nido", "Coron", "San Vicente", "Rizal", "Cuyo", 
    "Araceli", "Magsaysay", "Bataraza", "Dumaran"
  ],
  "Romblon": [
    "Romblon", "Odiongan", "Calatrava", "Alcantara", "San Agustin", "San Fernando", 
    "Concepcion", "Banton", "Corcuera", "San Jose"
  ],
  "Albay": [
    "Legazpi City", "Tabaco City", "Ligao City", "Daraga", "Guinobatan", "Malilipot", 
    "Oas", "Pio Duran", "Camalig", "Jovellar"
  ],
  "Camarines Norte": [
    "Daet", "Mercedes", "Labo", "Basud", "Jose Panganiban", "Vinzons", "Talisay", 
    "San Vicente", "Paracale", "San Lorenzo"
  ],
  "Camarines Sur": [
    "Naga City", "Iriga City", "Baao", "Bato", "Sipocot", "Calabanga", "Caramoan", 
    "Gainza", "Lupi", "Pasacao"
  ],
  "Catanduanes": [
    "Virac", "Pandan", "San Andres", "San Miguel", "Bato", "Caramoran", "Bagamanoc"
  ],
  "Masbate": [
    "Masbate City", "Aroroy", "Balud", "Cataingan", "Mandaon", "Milagros", "Placer", 
    "Palanas", "Claveria", "San Jacinto"
  ],
  "Sorsogon": [
    "Sorsogon City", "Bulusan", "Casiguran", "Donsol", "Irosin", "Magallanes", 
    "Pto. Diaz", "Barcelona", "Gubat", "Santa Magdalena"
  ],
  "Abra": [
    "Bangued", "Lagangilang", "Luba", "Pidigan", "Lagayan", "Bucloc", "San Juan", 
    "Dolores", "Pitag", "Manabo"
  ],
  "Apayao": [
    "Conner", "Kabugao", "Pudtol", "Calanasan", "Santa Marcela", "Flora", "Sta. Ana"
  ],
  "Benguet": [
    "La Trinidad", "Baguio City", "Itogon", "Tuba", "Sablan", "Tublay", "Atok", 
    "Mankayan", "Bakun", "Buguias"
  ],
  "Ifugao": [
    "Nayon", "Hingyon", "Lamut", "Luna", "Alfonso Lista", "Asipulo", "Hungduan", 
    "Mayoyao", "Natonin", "Tinoc"
  ],
  "Kalinga": [
    "Tabuk City", "Balbalan", "Lubuagan", "Pasil", "Rizal", "Pinukpuk", "Purok", 
    "Bangao", "Conner", "Kalinga"
  ],
  "Mountain Province": [
    "Bontoc", "Sabangan", "Sagada", "Tadian", "Besao", "Bauko", "Paracelis", 
    "Natonin", "Sabangan", "Bauko"
  ],
  // Visayas
  "Aklan": [
    "Kalibo", "Malay", "Banga", "Batan", "New Washington", "Libacao", "Numancia", 
    "Balete", "Makato", "Tangalan"
  ],
  "Antique": [
    "San Jose de Buenavista", "Hamtic", "Sibalom", "Patnongon", "Culasi", "Barbaza", 
    "Valderrama", "Pandan", "Bugasong", "Tibiao"
  ],
  "Capiz": [
    "Roxas City", "Panitan", "Pilar", "Dao", "Mambusao", "Tapaz", "Ivisan", "Mambusao", 
    "President Roxas", "Pilar"
  ],
  "Guimaras": [
    "Jordan", "Bayang", "Buenavista", "Saragosa", "San Lorenzo", "San Miguel", 
    "Sibunag", "Aglinab", "Villarosa", "Panglao"
  ],
  "Iloilo": [
    "Iloilo City", "Passi City", "San Miguel", "San Joaquin", "San Enrique", "Janiuay", 
    "Dingle", "Alimodian", "Dulungan", "Zarraga"
  ],
  "Negros Occidental": [
    "Bacolod City", "San Carlos City", "Cadiz City", "Silay City", "Victorias City", 
    "Talisay City", "Escalante City", "Bago City", "Hinigaran", "Manapla"
  ],
  "Negros Oriental": [
    "Dumaguete City", "Bais City", "Tanjay City", "Bayawan City", "Guihulngan City", 
    "Jimalalud", "Amlan", "Canlaon City", "Tanjay", "Valencia"
  ],
  "Siquijor": [
    "Siquijor", "Larena", "San Juan", "Lazi", "Maria", "Siquijor", "Siquijor", 
    "Siquijor", "San Juan", "Lazi"
  ],
  // Mindanao
  "Bukidnon": [
    "Malaybalay City", "Valencia City", "Maramag", "Manolo Fortich", "Quezon", "Cabanglasan", 
    "Kibawe", "Libona", "Sumilao", "Baungon"
  ],
  "Camiguin": [
    "Mambajao", "Catarman", "Sagay", "Guinsiliban", "Mahinog", "Tulang", "Tibasak"
  ],
  "Lanao del Norte": [
    "Tubod", "Iligan City", "Kapatagan", "Kauswagan", "Linamon", "Maigo", "Santo Niño", 
    "Salvador", "Nunungan", "Tangcal"
  ],
  "Misamis Occidental": [
    "Ozamiz City", "Tangub City", "Oroquieta City", "Oroquieta", "Don Victoriano Chiongbian", 
    "Aloran", "Clarin", "Jimenez", "Plaridel", "Baliangao"
  ],
  "Misamis Oriental": [
    "Cagayan de Oro City", "Gingoog City", "El Salvador City", "Tagoloan", "Villanueva", 
    "Opol", "Jasaan", "Magsaysay", "Balingasag", "Claveria"
  ],
  "Davao de Oro": [
    "Nabunturan", "Montevista", "Mabini", "Pantukan", "Maragusan", "Laak", "Tagum City"
  ],
  "Davao del Norte": [
    "Tagum City", "Panabo City", "Samal City", "Braulio E. Dujali", "Kapalong", "Talaingod", 
    "Asuncion", "Santo Tomas", "Bajay", "Tagum"
  ],
  "Davao del Sur": [
    "Digos City", "Santa Cruz", "Bansalan", "Hagonoy", "Sulop", "Magsaysay", 
    "Kiblawan", "Malalag", "Davao City", "Sta. Maria"
  ],
  "Davao Oriental": [
    "Mati City", "Baganga", "Cateel", "Caraga", "San Isidro", "Governor Generoso", 
    "Banaybanay", "Mabini", "Lupon", "Baganga"
  ],
  "Davao Occidental": [
    "Santiago", "Malita", "Don Marcelino", "Santa Maria", "Jose Abad Santos", 
    "Sarangani", "Lamalera"
  ],
  "Cotabato": [
    "Kidapawan City", "Midsayap", "Pikit", "Makilala", "Alamada", "Kabacan", 
    "Arakan", "Antipas", "Carmen", "Magpet"
  ],
  "Sarangani": [
    "Alabel", "Glan", "Malungon", "Maasim", "Kiamba", "Sarangani", "T'boli"
  ],
  "Sultan Kudarat": [
    "Isulan", "Tacurong City", "Columbio", "Lambayong", "Palimbang", "Bagumbayan", 
    "Esperanza", "Sen. Ninoy Aquino", "Bagumbayan", "Lambayong"
  ],
  "South Cotabato": [
    "Koronadal City", "General Santos City", "Surallah", "T'boli", "Lake Sebu", 
    "Polomolok", "Tupi", "Banga", "Norala", "Sto. Niño"
  ],
  "General Santos City": [
    "General Santos City"
  ],
  "Basilan": [
    "Isabela City", "Lamitan City", "Lantawan", "Maluso", "Sumisip", "Tipo-Tipo", 
    "Ungkaya Pukan", "Bacungan", "Kapatagan", "Liwanag"
  ],
  "Lanao del Sur": [
    "Marawi City", "Malabang", "Balindong", "Balo-i", "Kapatagan", "Lumbayanague", 
    "Masiu", "Sultan Dumalondong", "Tubaran", "Ditsaan-Ramain"
  ],
  "Maguindanao": [
    "Cotabato City", "Datu Odin Sinsuat", "Datu Piang", "Datu Unsay", "Mamasapano", 
    "Pagalungan", "Shariff Aguak", "Matanog", "Datu Anggal Midtimbang", "Datu Salibo"
  ],
  "Sulu": [
    "Jolo", "Indanan", "Patikul", "Pata", "Talipao", "Parang", "Omar", 
    "Maimbung", "Siasi", "Luuk"
  ],
  "Tawi-Tawi": [
    "Bongao", "Sapa-Sapa", "Simunul", "Sitangkai", "Mapun", "Sapa-Sapa", 
    "Tawi-Tawi", "Panglima Sugala", "Languyan", "Bongao"
  ],
  "Agusan del Norte": [
    "Cabadbaran City", "Butuan City", "Nasipit", "Carmen", "Kitcharao", 
    "Las Nieves", "Santiago", "Tubay", "Buenavista", "Jabonga"
  ],
  "Agusan del Sur": [
    "Prosperidad", "Bunawan", "Bayugan City", "San Francisco", "Veruela", 
    "Talacogon", "Lapinig", "Rosario", "Loreto", "Las Nieves"
  ],
  "Biliran": [
    "Naval", "Biliran", "Caibiran", "Culaba", "Kawayan", "Maripipi", "Almeria"
  ],
  "Surigao del Norte": [
    "Surigao City", "Dapa", "Del Carmen", "Santa Monica", "General Luna", 
    "Tagana-an", "Sison", "San Benito", "San Francisco", "San Isidro"
  ],
  "Surigao del Sur": [
    "Tandag City", "Bislig City", "Lanuza", "Lianga", "Carrascal", "Cagwait", 
    "Tagbina", "San Miguel", "San Agustin", "Madrid"
  ],
  "Dinagat Islands": [
    "San Jose", "Cagdianao", "Dinagat", "Libjo", "San Francisco", "Tubajon"
  ],
  "Siargao": [
    "Dapa", "General Luna", "Del Carmen", "Santa Monica", "San Benito", "San Isidro"
  ],
  "Cebu": [
    "Cebu City", "Mandaue City", "Lapu-Lapu City", "Carcar City", "Danao City", 
    "Bogo City", "Talisay City", "Toledo City", "Naga City", "San Fernando", 
    "Sogod", "Bantayan", "Cordova", "Minglanilla", "Pilar", "Poro", 
    "San Remigio", "Tabogon", "Tabuelan", "Dalaguete", "Argao", "Alcoy", 
    "Aloguinsan", "Balamban", "Barili", "Bogo", "Borbon", "Carmen", 
    "Dumanjug", "Ginatilan", "Malabuyoc", "Moalboal", "Pinamungahan", 
    "Ronda", "Samboan", "Sibonga", "Sogod", "Tanauan", "Tudela"
  ],
};
