SELECT DISTINCT ON (p.best_title_norm)
p.best_title_norm,
b.record_type_code||b.record_num||'a',
--id2reckey(p.bib_record_id)||'a',
--p.bib_record_id,
p.best_author
FROM
sierra_view.bib_record_property p
JOIN
sierra_view.bib_view b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a' AND
p.publish_year IN ('2017','2018') AND
(LOWER(p.best_title_norm) LIKE '1947 where n%' AND p.best_author LIKE '%Åsbrin%') OR
(LOWER(p.best_title_norm) LIKE '84k%' AND p.best_author LIKE '%North%') OR
(LOWER(p.best_title_norm) LIKE 'carnival of %' AND p.best_author LIKE '%Hall%') OR
(LOWER(p.best_title_norm) LIKE 'common table%' AND p.best_author LIKE '%McTern%') OR
(LOWER(p.best_title_norm) LIKE 'cruelty spec%' AND p.best_author LIKE '%Jungmi%') OR
(LOWER(p.best_title_norm) LIKE 'duke by defa%' AND p.best_author LIKE '%Cole%') OR
(LOWER(p.best_title_norm) LIKE 'gift from da%' AND p.best_author LIKE '%Ibrahi%') OR
(LOWER(p.best_title_norm) LIKE 'hard rain am%' AND p.best_author LIKE '%Gailla%') OR
(LOWER(p.best_title_norm) LIKE 'life of my o%' AND p.best_author LIKE '%Tomali%') OR
(LOWER(p.best_title_norm) LIKE 'lucky man st%' AND p.best_author LIKE '%Brinkl%') OR
(LOWER(p.best_title_norm) LIKE 'new reality %' AND p.best_author LIKE '%Salk a%') OR
(LOWER(p.best_title_norm) LIKE 'place for us%' AND p.best_author LIKE '%Farhee%') OR
(LOWER(p.best_title_norm) LIKE 'river of sta%' AND p.best_author LIKE '%Hua%') OR
(LOWER(p.best_title_norm) LIKE 'room away fr%' AND p.best_author LIKE '%Suma%') OR
(LOWER(p.best_title_norm) LIKE 'stitch in ti%' AND p.best_author LIKE '%Kalmar%') OR
(LOWER(p.best_title_norm) LIKE 'thousand beg%' AND p.best_author LIKE '%Oh%') OR
(LOWER(p.best_title_norm) LIKE 'achtung baby%' AND p.best_author LIKE '%Zaske%') OR
(LOWER(p.best_title_norm) LIKE 'all the anim%' AND p.best_author LIKE '%Stead%') OR
(LOWER(p.best_title_norm) LIKE 'all the answ%' AND p.best_author LIKE '%Kupper%') OR
(LOWER(p.best_title_norm) LIKE 'all the name%' AND p.best_author LIKE '%Sachde%') OR
(LOWER(p.best_title_norm) LIKE 'all you can %' AND p.best_author LIKE '%Chung%') OR
(LOWER(p.best_title_norm) LIKE 'amal unbound%' AND p.best_author LIKE '%Saeed%') OR
(LOWER(p.best_title_norm) LIKE 'america is n%' AND p.best_author LIKE '%Castil%') OR
(LOWER(p.best_title_norm) LIKE 'american hat%' AND p.best_author LIKE '%Singh %') OR
(LOWER(p.best_title_norm) LIKE 'american pri%' AND p.best_author LIKE '%Bauer%') OR
(LOWER(p.best_title_norm) LIKE 'american mar%' AND p.best_author LIKE '%Jones%') OR
(LOWER(p.best_title_norm) LIKE 'ana maria re%' AND p.best_author LIKE '%Eunice%') OR
(LOWER(p.best_title_norm) LIKE 'and now we h%' AND p.best_author LIKE '%O''Con%') OR
(LOWER(p.best_title_norm) LIKE 'antisocial m%' AND p.best_author LIKE '%Vaidhy%') OR
(LOWER(p.best_title_norm) LIKE 'arthur ashe %' AND p.best_author LIKE '%Arsena%') OR
(LOWER(p.best_title_norm) LIKE 'asymmetry a %' AND p.best_author LIKE '%Hallid%') OR
(LOWER(p.best_title_norm) LIKE 'bachelor nat%' AND p.best_author LIKE '%Kaufma%') OR
(LOWER(p.best_title_norm) LIKE 'back talk st%' AND p.best_author LIKE '%Lazari%') OR
(LOWER(p.best_title_norm) LIKE 'bad blood se%' AND p.best_author LIKE '%Carrey%') OR
(LOWER(p.best_title_norm) LIKE 'ball lightni%' AND p.best_author LIKE '%Liu%') OR
(LOWER(p.best_title_norm) LIKE 'barracoon th%' AND p.best_author LIKE '%Neale %') OR
(LOWER(p.best_title_norm) LIKE 'be prepared%' AND p.best_author LIKE '%Brosgo%') OR
(LOWER(p.best_title_norm) LIKE 'becoming%' AND p.best_author LIKE '%Obama%') OR
(LOWER(p.best_title_norm) LIKE 'belonging a %' AND p.best_author LIKE '%Krug%') OR
(LOWER(p.best_title_norm) LIKE 'beneath a ru%' AND p.best_author LIKE '%King%') OR
(LOWER(p.best_title_norm) LIKE 'big game the%' AND p.best_author LIKE '%Leibov%') OR
(LOWER(p.best_title_norm) LIKE 'bingo love%' AND p.best_author LIKE '%Frankl%') OR
(LOWER(p.best_title_norm) LIKE 'bitter orang%' AND p.best_author LIKE '%Fuller%') OR
(LOWER(p.best_title_norm) LIKE 'bloody rose%' AND p.best_author LIKE '%Eames%') OR
(LOWER(p.best_title_norm) LIKE 'blue%' AND p.best_author LIKE '%Vaccar%') OR
(LOWER(p.best_title_norm) LIKE 'boom town th%' AND p.best_author LIKE '%Anders%') OR
(LOWER(p.best_title_norm) LIKE 'born to be p%' AND p.best_author LIKE '%Dery%') OR
(LOWER(p.best_title_norm) LIKE 'brown poems%' AND p.best_author LIKE '%Young%') OR
(LOWER(p.best_title_norm) LIKE 'cake a cookb%' AND p.best_author LIKE '%Kalman%') OR
(LOWER(p.best_title_norm) LIKE 'calypso%' AND p.best_author LIKE '%Sedari%') OR
(LOWER(p.best_title_norm) LIKE 'census%' AND p.best_author LIKE '%Ball%') OR
(LOWER(p.best_title_norm) LIKE 'cenzontle%' AND p.best_author LIKE '%Hernan%') OR
(LOWER(p.best_title_norm) LIKE 'chasing hill%' AND p.best_author LIKE '%Chozic%') OR
(LOWER(p.best_title_norm) LIKE 'che a revolu%' AND p.best_author LIKE '%Anders%') OR
(LOWER(p.best_title_norm) LIKE 'check please%' AND p.best_author LIKE '%Ukazu%') OR
(LOWER(p.best_title_norm) LIKE 'chesapeake r%' AND p.best_author LIKE '%Swift%') OR
(LOWER(p.best_title_norm) LIKE 'children of %' AND p.best_author LIKE '%Adeyem%') OR
(LOWER(p.best_title_norm) LIKE 'circe%' AND p.best_author LIKE '%Miller%') OR
(LOWER(p.best_title_norm) LIKE 'citizen ille%' AND p.best_author LIKE '%Olivar%') OR
(LOWER(p.best_title_norm) LIKE 'city of ash %' AND p.best_author LIKE '%Pyun%') OR
(LOWER(p.best_title_norm) LIKE 'come again%' AND p.best_author LIKE '%Powell%') OR
(LOWER(p.best_title_norm) LIKE 'come west an%' AND p.best_author LIKE '%Loskut%') OR
(LOWER(p.best_title_norm) LIKE 'comfort in a%' AND p.best_author LIKE '%Clark%') OR
(LOWER(p.best_title_norm) LIKE 'conspiracy p%' AND p.best_author LIKE '%Holida%') OR
(LOWER(p.best_title_norm) LIKE 'contact high%' AND p.best_author LIKE '%Tobak%') OR
(LOWER(p.best_title_norm) LIKE 'coyote doggi%' AND p.best_author LIKE '%Hanawa%') OR
(LOWER(p.best_title_norm) LIKE 'cravings hun%' AND p.best_author LIKE '%Teigen%') OR
(LOWER(p.best_title_norm) LIKE 'creative que%' AND p.best_author LIKE '%Questlove%') OR
(LOWER(p.best_title_norm) LIKE 'crudo a nove%' AND p.best_author LIKE '%Laing%') OR
(LOWER(p.best_title_norm) LIKE 'crux a cross%' AND p.best_author LIKE '%Guerre%') OR
(LOWER(p.best_title_norm) LIKE 'dactyl hill %' AND p.best_author LIKE '%José O%') OR
(LOWER(p.best_title_norm) LIKE 'dancing bear%' AND p.best_author LIKE '%Szablo%') OR
(LOWER(p.best_title_norm) LIKE 'darwin comes%' AND p.best_author LIKE '%Schilt%') OR
(LOWER(p.best_title_norm) LIKE 'death of a r%' AND p.best_author LIKE '%Loewen%') OR
(LOWER(p.best_title_norm) LIKE 'deviation a %' AND p.best_author LIKE '%D''Era%') OR
(LOWER(p.best_title_norm) LIKE 'do not lick %' AND p.best_author LIKE '%Ben-Ba%') OR
(LOWER(p.best_title_norm) LIKE 'doing harm t%' AND p.best_author LIKE '%Dusenb%') OR
(LOWER(p.best_title_norm) LIKE 'dragons in a%' AND p.best_author LIKE '%Elliot%') OR
(LOWER(p.best_title_norm) LIKE 'drawn togeth%' AND p.best_author LIKE '%Lê%') OR
(LOWER(p.best_title_norm) LIKE 'dreamers%' AND p.best_author LIKE '%Morale%') OR
(LOWER(p.best_title_norm) LIKE 'educated a m%' AND p.best_author LIKE '%Westov%') OR
(LOWER(p.best_title_norm) LIKE 'eloquent rag%' AND p.best_author LIKE '%Cooper%') OR
(LOWER(p.best_title_norm) LIKE 'emergency co%' AND p.best_author LIKE '%Choi%') OR
(LOWER(p.best_title_norm) LIKE 'enlightenmen%' AND p.best_author LIKE '%Pinker%') OR
(LOWER(p.best_title_norm) LIKE 'eternity gir%' AND p.best_author LIKE '%Visagg%') OR
(LOWER(p.best_title_norm) LIKE 'everyday dor%' AND p.best_author LIKE '%Greens%') OR
(LOWER(p.best_title_norm) LIKE 'everything y%' AND p.best_author LIKE '%Higgin%') OR
(LOWER(p.best_title_norm) LIKE 'exit stage l%' AND p.best_author LIKE '%Russel%') OR
(LOWER(p.best_title_norm) LIKE 'famous fathe%' AND p.best_author LIKE '%Bernst%') OR
(LOWER(p.best_title_norm) LIKE 'fascism a wa%' AND p.best_author LIKE '%Albrig%') OR
(LOWER(p.best_title_norm) LIKE 'fear trump i%' AND p.best_author LIKE '%Woodwa%') OR
(LOWER(p.best_title_norm) LIKE 'feast food o%' AND p.best_author LIKE '%Helou%') OR
(LOWER(p.best_title_norm) LIKE 'feel free es%' AND p.best_author LIKE '%Smith%') OR
(LOWER(p.best_title_norm) LIKE 'florida%' AND p.best_author LIKE '%Groff%') OR
(LOWER(p.best_title_norm) LIKE 'forever or a%' AND p.best_author LIKE '%Jacoby%') OR
(LOWER(p.best_title_norm) LIKE 'freshwater%' AND p.best_author LIKE '%Emezi%') OR
(LOWER(p.best_title_norm) LIKE 'from twinkle%' AND p.best_author LIKE '%Menon%') OR
(LOWER(p.best_title_norm) LIKE 'front desk%' AND p.best_author LIKE '%Yang%') OR
(LOWER(p.best_title_norm) LIKE 'full disclos%' AND p.best_author LIKE '%Daniel%') OR
(LOWER(p.best_title_norm) LIKE 'ghosts in th%' AND p.best_author LIKE '%Ewing%') OR
(LOWER(p.best_title_norm) LIKE 'girls burn b%' AND p.best_author LIKE '%Rao%') OR
(LOWER(p.best_title_norm) LIKE 'give me some%' AND p.best_author LIKE '%Ganswo%') OR
(LOWER(p.best_title_norm) LIKE 'give me your%' AND p.best_author LIKE '%Abbott%') OR
(LOWER(p.best_title_norm) LIKE 'gnomon a nov%' AND p.best_author LIKE '%Harkaw%') OR
(LOWER(p.best_title_norm) LIKE 'god save tex%' AND p.best_author LIKE '%Wright%') OR
(LOWER(p.best_title_norm) LIKE 'good and mad%' AND p.best_author LIKE '%Traist%') OR
(LOWER(p.best_title_norm) LIKE 'greeks beari%' AND p.best_author LIKE '%Kerr%') OR
(LOWER(p.best_title_norm) LIKE 'grist mill r%' AND p.best_author LIKE '%Yates%') OR
(LOWER(p.best_title_norm) LIKE 'half-witch%' AND p.best_author LIKE '%Schoff%') OR
(LOWER(p.best_title_norm) LIKE 'happiness a %' AND p.best_author LIKE '%Forna%') OR
(LOWER(p.best_title_norm) LIKE 'heads of the%' AND p.best_author LIKE '%Thomps%') OR
(LOWER(p.best_title_norm) LIKE 'heart berrie%' AND p.best_author LIKE '%Marie %') OR
(LOWER(p.best_title_norm) LIKE 'heartland a %' AND p.best_author LIKE '%Smarsh%') OR
(LOWER(p.best_title_norm) LIKE 'heavy an ame%' AND p.best_author LIKE '%Laymon%') OR
(LOWER(p.best_title_norm) LIKE 'here to stay%' AND p.best_author LIKE '%Fariza%') OR
(LOWER(p.best_title_norm) LIKE 'hey kiddo%' AND p.best_author LIKE '%Krosoc%') OR
(LOWER(p.best_title_norm) LIKE 'hiking with %' AND p.best_author LIKE '%Kaag%') OR
(LOWER(p.best_title_norm) LIKE 'his favorite%' AND p.best_author LIKE '%Walber%') OR
(LOWER(p.best_title_norm) LIKE 'homelands fo%' AND p.best_author LIKE '%Corcha%') OR
(LOWER(p.best_title_norm) LIKE 'housegirl a %' AND p.best_author LIKE '%Donkor%') OR
(LOWER(p.best_title_norm) LIKE 'how are you %' AND p.best_author LIKE '%Holmes%') OR
(LOWER(p.best_title_norm) LIKE 'how long til%' AND p.best_author LIKE '%Jemisi%') OR
(LOWER(p.best_title_norm) LIKE 'how to be a %' AND p.best_author LIKE '%Vere%') OR
(LOWER(p.best_title_norm) LIKE 'how to chang%' AND p.best_author LIKE '%Pollan%') OR
(LOWER(p.best_title_norm) LIKE 'how to inven%' AND p.best_author LIKE '%North%') OR
(LOWER(p.best_title_norm) LIKE 'how to write%' AND p.best_author LIKE '%Chee%') OR
(LOWER(p.best_title_norm) LIKE 'if you see m%' AND p.best_author LIKE '%Patel%') OR
(LOWER(p.best_title_norm) LIKE 'in pieces%' AND p.best_author LIKE '%Field%') OR
(LOWER(p.best_title_norm) LIKE 'indianapolis%' AND p.best_author LIKE '%Vincen%') OR
(LOWER(p.best_title_norm) LIKE 'infidel%' AND p.best_author LIKE '%Pichet%') OR
(LOWER(p.best_title_norm) LIKE 'inner city p%' AND p.best_author LIKE '%Hancox%') OR
(LOWER(p.best_title_norm) LIKE 'inseparable %' AND p.best_author LIKE '%Huang%') OR
(LOWER(p.best_title_norm) LIKE 'intercepted %' AND p.best_author LIKE '%Martin%') OR
(LOWER(p.best_title_norm) LIKE 'into the rag%' AND p.best_author LIKE '%Slade%') OR
(LOWER(p.best_title_norm) LIKE 'iron gold%' AND p.best_author LIKE '%Brown%') OR
(LOWER(p.best_title_norm) LIKE 'israeli soul%' AND p.best_author LIKE '%Solomo%') OR
(LOWER(p.best_title_norm) LIKE 'ivy aberdeen%' AND p.best_author LIKE '%Herrin%') OR
(LOWER(p.best_title_norm) LIKE 'jam session %' AND p.best_author LIKE '%Goldst%') OR
(LOWER(p.best_title_norm) LIKE 'julián is a %' AND p.best_author LIKE '%Love%') OR
(LOWER(p.best_title_norm) LIKE 'junk%' AND p.best_author LIKE '%Pico%') OR
(LOWER(p.best_title_norm) LIKE 'just the fun%' AND p.best_author LIKE '%Scovel%') OR
(LOWER(p.best_title_norm) LIKE 'lake success%' AND p.best_author LIKE '%Shteyn%') OR
(LOWER(p.best_title_norm) LIKE 'leadership i%' AND p.best_author LIKE '%Kearns%') OR
(LOWER(p.best_title_norm) LIKE 'like a mothe%' AND p.best_author LIKE '%Garbes%') OR
(LOWER(p.best_title_norm) LIKE 'listen to th%' AND p.best_author LIKE '%Jay Os%') OR
(LOWER(p.best_title_norm) LIKE 'little a nov%' AND p.best_author LIKE '%Carey%') OR
(LOWER(p.best_title_norm) LIKE 'louisianas w%' AND p.best_author LIKE '%DiCami%') OR
(LOWER(p.best_title_norm) LIKE 'love%' AND p.best_author LIKE '%de la %') OR
(LOWER(p.best_title_norm) LIKE 'luisa – now %' AND p.best_author LIKE '%Maurel%') OR
(LOWER(p.best_title_norm) LIKE 'making up%' AND p.best_author LIKE '%Parker%') OR
(LOWER(p.best_title_norm) LIKE 'mariam sharm%' AND p.best_author LIKE '%Karim%') OR
(LOWER(p.best_title_norm) LIKE 'mastering fe%' AND p.best_author LIKE '%Webb%') OR
(LOWER(p.best_title_norm) LIKE 'melmoth a no%' AND p.best_author LIKE '%Perry%') OR
(LOWER(p.best_title_norm) LIKE 'memphis rent%' AND p.best_author LIKE '%Gordon%') OR
(LOWER(p.best_title_norm) LIKE 'midden%' AND p.best_author LIKE '%Bouwsm%') OR
(LOWER(p.best_title_norm) LIKE 'milk street %' AND p.best_author LIKE '%Kimbal%') OR
(LOWER(p.best_title_norm) LIKE 'milkman a no%' AND p.best_author LIKE '%Burns%') OR
(LOWER(p.best_title_norm) LIKE 'mommys khima%' AND p.best_author LIKE '%Thompk%') OR
(LOWER(p.best_title_norm) LIKE 'monster port%' AND p.best_author LIKE '%Samata%') OR
(LOWER(p.best_title_norm) LIKE 'monument poe%' AND p.best_author LIKE '%Trethe%') OR
(LOWER(p.best_title_norm) LIKE 'motherhood a%' AND p.best_author LIKE '%Heti%') OR
(LOWER(p.best_title_norm) LIKE 'my brothers %' AND p.best_author LIKE '%Tagame%') OR
(LOWER(p.best_title_norm) LIKE 'my ex-life a%' AND p.best_author LIKE '%McCaul%') OR
(LOWER(p.best_title_norm) LIKE 'my life as a%' AND p.best_author LIKE '%Branum%') OR
(LOWER(p.best_title_norm) LIKE 'my own devic%' AND p.best_author LIKE '%Dessa%') OR
(LOWER(p.best_title_norm) LIKE 'my sister th%' AND p.best_author LIKE '%Braith%') OR
(LOWER(p.best_title_norm) LIKE 'my so-called%' AND p.best_author LIKE '%Sharma%') OR
(LOWER(p.best_title_norm) LIKE 'my year of r%' AND p.best_author LIKE '%Moshfe%') OR
(LOWER(p.best_title_norm) LIKE 'network prop%' AND p.best_author LIKE '%Benkle%') OR
(LOWER(p.best_title_norm) LIKE 'new poets of%' AND p.best_author LIKE '%EErdri%') OR
(LOWER(p.best_title_norm) LIKE 'new shoes%' AND p.best_author LIKE '%Raschk%') OR
(LOWER(p.best_title_norm) LIKE 'night moves%' AND p.best_author LIKE '%Hopper%') OR
(LOWER(p.best_title_norm) LIKE 'ninety-nine %' AND p.best_author LIKE '%Brown%') OR
(LOWER(p.best_title_norm) LIKE 'not my idea %' AND p.best_author LIKE '%Higgin%') OR
(LOWER(p.best_title_norm) LIKE 'now & again %' AND p.best_author LIKE '%Turshe%') OR
(LOWER(p.best_title_norm) LIKE 'number one c%' AND p.best_author LIKE '%Li%') OR
(LOWER(p.best_title_norm) LIKE 'odd one out%' AND p.best_author LIKE '%Stone%') OR
(LOWER(p.best_title_norm) LIKE 'ohio%' AND p.best_author LIKE '%Markle%') OR
(LOWER(p.best_title_norm) LIKE 'on the other%' AND p.best_author LIKE '%Mckess%') OR
(LOWER(p.best_title_norm) LIKE 'once and for%' AND p.best_author LIKE '%Miyaza%') OR
(LOWER(p.best_title_norm) LIKE 'one person n%' AND p.best_author LIKE '%Anders%') OR
(LOWER(p.best_title_norm) LIKE 'only to slee%' AND p.best_author LIKE '%Osborn%') OR
(LOWER(p.best_title_norm) LIKE 'ottolenghi s%' AND p.best_author LIKE '%Ottole%') OR
(LOWER(p.best_title_norm) LIKE 'packing my l%' AND p.best_author LIKE '%Mangue%') OR
(LOWER(p.best_title_norm) LIKE 'palaces for %' AND p.best_author LIKE '%Klinen%') OR
(LOWER(p.best_title_norm) LIKE 'photographic%' AND p.best_author LIKE '%Quinte%') OR
(LOWER(p.best_title_norm) LIKE 'playing chan%' AND p.best_author LIKE '%Chinen%') OR
(LOWER(p.best_title_norm) LIKE 'pride%' AND p.best_author LIKE '%Zoboi%') OR
(LOWER(p.best_title_norm) LIKE 'rage becomes%' AND p.best_author LIKE '%Chemal%') OR
(LOWER(p.best_title_norm) LIKE 'record of a %' AND p.best_author LIKE '%Chambe%') OR
(LOWER(p.best_title_norm) LIKE 'red white bl%' AND p.best_author LIKE '%Carpen%') OR
(LOWER(p.best_title_norm) LIKE 'sabrina%' AND p.best_author LIKE '%Drnaso%') OR
(LOWER(p.best_title_norm) LIKE 'sadie%' AND p.best_author LIKE '%Summer%') OR
(LOWER(p.best_title_norm) LIKE 'scribe a nov%' AND p.best_author LIKE '%Hagy%') OR
(LOWER(p.best_title_norm) LIKE 'sea prayer%' AND p.best_author LIKE '%Hossei%') OR
(LOWER(p.best_title_norm) LIKE 'seafire%' AND p.best_author LIKE '%Parker%') OR
(LOWER(p.best_title_norm) LIKE 'searing insp%' AND p.best_author LIKE '%Vollan%') OR
(LOWER(p.best_title_norm) LIKE 'severance%' AND p.best_author LIKE '%Ma%') OR
(LOWER(p.best_title_norm) LIKE 'shade the ch%' AND p.best_author LIKE '%Castel%') OR
(LOWER(p.best_title_norm) LIKE 'sharp%' AND p.best_author LIKE '%Dean%') OR
(LOWER(p.best_title_norm) LIKE 'she begat th%' AND p.best_author LIKE '%Morgan%') OR
(LOWER(p.best_title_norm) LIKE 'sketchtasy%' AND p.best_author LIKE '%Bernst%') OR
(LOWER(p.best_title_norm) LIKE 'small animal%' AND p.best_author LIKE '%Brooks%') OR
(LOWER(p.best_title_norm) LIKE 'small fry%' AND p.best_author LIKE '%Brenna%') OR
(LOWER(p.best_title_norm) LIKE 'social creat%' AND p.best_author LIKE '%Isabel%') OR
(LOWER(p.best_title_norm) LIKE 'some trick t%' AND p.best_author LIKE '%DeWitt%') OR
(LOWER(p.best_title_norm) LIKE 'space opera%' AND p.best_author LIKE '%Valent%') OR
(LOWER(p.best_title_norm) LIKE 'spinning sil%' AND p.best_author LIKE '%Novik%') OR
(LOWER(p.best_title_norm) LIKE 'split tooth%' AND p.best_author LIKE '%Tagaq%') OR
(LOWER(p.best_title_norm) LIKE 'stealing the%' AND p.best_author LIKE '%Press%') OR
(LOWER(p.best_title_norm) LIKE 'tell the mac%' AND p.best_author LIKE '%Willia%') OR
(LOWER(p.best_title_norm) LIKE 'terra nulliu%' AND p.best_author LIKE '%Colema%') OR
(LOWER(p.best_title_norm) LIKE 'tess of the %' AND p.best_author LIKE '%Hartma%') OR
(LOWER(p.best_title_norm) LIKE 'text me when%' AND p.best_author LIKE '%Schaef%') OR
(LOWER(p.best_title_norm) LIKE 'that kind of%' AND p.best_author LIKE '%Alam%') OR
(LOWER(p.best_title_norm) LIKE 'art of gathe%' AND p.best_author LIKE '%Parker%') OR
(LOWER(p.best_title_norm) LIKE 'artful evolu%' AND p.best_author LIKE '%White,%') OR
(LOWER(p.best_title_norm) LIKE 'assassinatio%' AND p.best_author LIKE '%Anders%') OR
(LOWER(p.best_title_norm) LIKE 'benefits of %' AND p.best_author LIKE '%Braden%') OR
(LOWER(p.best_title_norm) LIKE 'cabin at the%' AND p.best_author LIKE '%Trembl%') OR
(LOWER(p.best_title_norm) LIKE 'carrying poe%' AND p.best_author LIKE '%Limón%') OR
(LOWER(p.best_title_norm) LIKE 'chalk man a %' AND p.best_author LIKE '%Tudor%') OR
(LOWER(p.best_title_norm) LIKE 'court dancer%' AND p.best_author LIKE '%Shin, %') OR
(LOWER(p.best_title_norm) LIKE 'dark descent%' AND p.best_author LIKE '%White%') OR
(LOWER(p.best_title_norm) LIKE 'death of mrs%' AND p.best_author LIKE '%Ware%') OR
(LOWER(p.best_title_norm) LIKE 'dragon slaye%' AND p.best_author LIKE '%Hernan%') OR
(LOWER(p.best_title_norm) LIKE 'electric sta%' AND p.best_author LIKE '%Stalen%') OR
(LOWER(p.best_title_norm) LIKE 'faithful spy%' AND p.best_author LIKE '%Hendri%') OR
(LOWER(p.best_title_norm) LIKE 'female persu%' AND p.best_author LIKE '%Wolitz%') OR
(LOWER(p.best_title_norm) LIKE 'field of blo%' AND p.best_author LIKE '%Freema%') OR
(LOWER(p.best_title_norm) LIKE 'fifth risk%' AND p.best_author LIKE '%Lewis%') OR
(LOWER(p.best_title_norm) LIKE 'fighters%' AND p.best_author LIKE '%Chiver%') OR
(LOWER(p.best_title_norm) LIKE 'foreign cine%' AND p.best_author LIKE '%Pirie %') OR
(LOWER(p.best_title_norm) LIKE 'friend a nov%' AND p.best_author LIKE '%Nunez%') OR
(LOWER(p.best_title_norm) LIKE 'girl in the %' AND p.best_author LIKE '%McGuir%') OR
(LOWER(p.best_title_norm) LIKE 'golden state%' AND p.best_author LIKE '%Kiesli%') OR
(LOWER(p.best_title_norm) LIKE 'great believ%' AND p.best_author LIKE '%Makkai%') OR
(LOWER(p.best_title_norm) LIKE 'hellfire clu%' AND p.best_author LIKE '%Tapper%') OR
(LOWER(p.best_title_norm) LIKE 'hollow of fe%' AND p.best_author LIKE '%Thomas%') OR
(LOWER(p.best_title_norm) LIKE 'house of bro%' AND p.best_author LIKE '%Albert%') OR
(LOWER(p.best_title_norm) LIKE 'house that l%' AND p.best_author LIKE '%Respic%') OR
(LOWER(p.best_title_norm) LIKE 'immortalists%' AND p.best_author LIKE '%Benjam%') OR
(LOWER(p.best_title_norm) LIKE 'incendiaries%' AND p.best_author LIKE '%Kwon%') OR
(LOWER(p.best_title_norm) LIKE 'infinite bla%' AND p.best_author LIKE '%Gran%') OR
(LOWER(p.best_title_norm) LIKE 'kiss quotien%' AND p.best_author LIKE '%Hoang%') OR
(LOWER(p.best_title_norm) LIKE 'largesse of %' AND p.best_author LIKE '%Johnso%') OR
(LOWER(p.best_title_norm) LIKE 'last cowboys%' AND p.best_author LIKE '%Branch%') OR
(LOWER(p.best_title_norm) LIKE 'library book%' AND p.best_author LIKE '%Orlean%') OR
(LOWER(p.best_title_norm) LIKE 'line becomes%' AND p.best_author LIKE '%Cantú%') OR
(LOWER(p.best_title_norm) LIKE 'many deaths %' AND p.best_author LIKE '%Koblis%') OR
(LOWER(p.best_title_norm) LIKE 'mars room a %' AND p.best_author LIKE '%Kushne%') OR
(LOWER(p.best_title_norm) LIKE 'merry spinst%' AND p.best_author LIKE '%Mallor%') OR
(LOWER(p.best_title_norm) LIKE 'mirage facto%' AND p.best_author LIKE '%Krist%') OR
(LOWER(p.best_title_norm) LIKE 'miscalculati%' AND p.best_author LIKE '%McAnul%') OR
(LOWER(p.best_title_norm) LIKE 'most dangero%' AND p.best_author LIKE '%Minuta%') OR
(LOWER(p.best_title_norm) LIKE 'night diary%' AND p.best_author LIKE '%Hirana%') OR
(LOWER(p.best_title_norm) LIKE 'order of the%' AND p.best_author LIKE '%Vuilla%') OR
(LOWER(p.best_title_norm) LIKE 'overstory a %' AND p.best_author LIKE '%Powers%') OR
(LOWER(p.best_title_norm) LIKE 'parker inher%' AND p.best_author LIKE '%Johnso%') OR
(LOWER(p.best_title_norm) LIKE 'party and ot%' AND p.best_author LIKE '%Ruzzie%') OR
(LOWER(p.best_title_norm) LIKE 'perfect nann%' AND p.best_author LIKE '%Sliman%') OR
(LOWER(p.best_title_norm) LIKE 'personality %' AND p.best_author LIKE '%Emre%') OR
(LOWER(p.best_title_norm) LIKE 'poet x%' AND p.best_author LIKE '%Aceved%') OR
(LOWER(p.best_title_norm) LIKE 'prince and t%' AND p.best_author LIKE '%Wang%') OR
(LOWER(p.best_title_norm) LIKE 'prison lette%' AND p.best_author LIKE '%Mandel%') OR
(LOWER(p.best_title_norm) LIKE 'real lolita %' AND p.best_author LIKE '%Weinma%') OR
(LOWER(p.best_title_norm) LIKE 'recovering i%' AND p.best_author LIKE '%Jamiso%') OR
(LOWER(p.best_title_norm) LIKE 'red and the %' AND p.best_author LIKE '%Kornac%') OR
(LOWER(p.best_title_norm) LIKE 'rough patch%' AND p.best_author LIKE '%Lies%') OR
(LOWER(p.best_title_norm) LIKE 'science of b%' AND p.best_author LIKE '%Keller%') OR
(LOWER(p.best_title_norm) LIKE 'season of st%' AND p.best_author LIKE '%Magoon%') OR
(LOWER(p.best_title_norm) LIKE 'silence of t%' AND p.best_author LIKE '%Barker%') OR
(LOWER(p.best_title_norm) LIKE 'sky is yours%' AND p.best_author LIKE '%Klang %') OR
(LOWER(p.best_title_norm) LIKE 'soul of amer%' AND p.best_author LIKE '%Meacha%') OR
(LOWER(p.best_title_norm) LIKE 'sparsholt af%' AND p.best_author LIKE '%Hollin%') OR
(LOWER(p.best_title_norm) LIKE 'strange case%' AND p.best_author LIKE '%Raffel%') OR
(LOWER(p.best_title_norm) LIKE 'summer of jo%' AND p.best_author LIKE '%Spaldi%') OR
(LOWER(p.best_title_norm) LIKE 'view from fl%' AND p.best_author LIKE '%Kendzi%') OR
(LOWER(p.best_title_norm) LIKE 'way you make%' AND p.best_author LIKE '%Goo%') OR
(LOWER(p.best_title_norm) LIKE 'wedding date%' AND p.best_author LIKE '%Guillo%') OR
(LOWER(p.best_title_norm) LIKE 'winter soldi%' AND p.best_author LIKE '%Mason%') OR
(LOWER(p.best_title_norm) LIKE 'witch elm a %' AND p.best_author LIKE '%French%') OR
(LOWER(p.best_title_norm) LIKE 'word is murd%' AND p.best_author LIKE '%Horowi%') OR
(LOWER(p.best_title_norm) LIKE 'world only s%' AND p.best_author LIKE '%Butler%') OR
(LOWER(p.best_title_norm) LIKE 'writers map %' AND p.best_author LIKE '%Lewis-%') OR
(LOWER(p.best_title_norm) LIKE 'wrong heaven%' AND p.best_author LIKE '%Bonnaf%') OR
(LOWER(p.best_title_norm) LIKE 'there there %' AND p.best_author LIKE '%Orange%') OR
(LOWER(p.best_title_norm) LIKE 'there will b%' AND p.best_author LIKE '%Gerald%') OR
(LOWER(p.best_title_norm) LIKE 'these truths%' AND p.best_author LIKE '%Lepore%') OR
(LOWER(p.best_title_norm) LIKE 'they say blu%' AND p.best_author LIKE '%Tamaki%') OR
(LOWER(p.best_title_norm) LIKE 'this is not %' AND p.best_author LIKE '%Purcel%') OR
(LOWER(p.best_title_norm) LIKE 'those who kn%' AND p.best_author LIKE '%Novey%') OR
(LOWER(p.best_title_norm) LIKE 'tigers & tea%' AND p.best_author LIKE '%Kerley%') OR
(LOWER(p.best_title_norm) LIKE 'to be honest%' AND p.best_author LIKE '%Ann Ma%') OR
(LOWER(p.best_title_norm) LIKE 'to throw awa%' AND p.best_author LIKE '%Albert%') OR
(LOWER(p.best_title_norm) LIKE 'trail of lig%' AND p.best_author LIKE '%Roanho%') OR
(LOWER(p.best_title_norm) LIKE 'transcriptio%' AND p.best_author LIKE '%Atkins%') OR
(LOWER(p.best_title_norm) LIKE 'turnip green%' AND p.best_author LIKE '%Hernan%') OR
(LOWER(p.best_title_norm) LIKE 'two sisters %' AND p.best_author LIKE '%Seiers%') OR
(LOWER(p.best_title_norm) LIKE 'unclaimed ba%' AND p.best_author LIKE '%Doll%') OR
(LOWER(p.best_title_norm) LIKE 'underbug an %' AND p.best_author LIKE '%Margon%') OR
(LOWER(p.best_title_norm) LIKE 'unholy land%' AND p.best_author LIKE '%Tidhar%') OR
(LOWER(p.best_title_norm) LIKE 'unsheltered %' AND p.best_author LIKE '%Kingso%') OR
(LOWER(p.best_title_norm) LIKE 'varina a nov%' AND p.best_author LIKE '%Frazie%') OR
(LOWER(p.best_title_norm) LIKE 'warlight a n%' AND p.best_author LIKE '%Ondaat%') OR
(LOWER(p.best_title_norm) LIKE 'washington b%' AND p.best_author LIKE '%Edugya%') OR
(LOWER(p.best_title_norm) LIKE 'we are grate%' AND p.best_author LIKE '%Sorell%') OR
(LOWER(p.best_title_norm) LIKE 'we dont eat %' AND p.best_author LIKE '%Higgin%') OR
(LOWER(p.best_title_norm) LIKE 'when katie m%' AND p.best_author LIKE '%Perri%') OR
(LOWER(p.best_title_norm) LIKE 'white fragil%' AND p.best_author LIKE '%DiAnge%') OR
(LOWER(p.best_title_norm) LIKE 'who is micha%' AND p.best_author LIKE '%Ovitz%') OR
(LOWER(p.best_title_norm) LIKE 'who is vera %' AND p.best_author LIKE '%Knecht%') OR
(LOWER(p.best_title_norm) LIKE 'why art%' AND p.best_author LIKE '%Davis%') OR
(LOWER(p.best_title_norm) LIKE 'winners take%' AND p.best_author LIKE '%Giridh%') OR
(LOWER(p.best_title_norm) LIKE 'witchmark%' AND p.best_author LIKE '%Polk%') OR
(LOWER(p.best_title_norm) LIKE 'you think it%' AND p.best_author LIKE '%Sitten%') OR
(LOWER(p.best_title_norm) LIKE 'your black f%' AND p.best_author LIKE '%Passmo%') OR
(LOWER(p.best_title_norm) LIKE 'your duck is%' AND p.best_author LIKE '%Eisenb%') OR
(LOWER(p.best_title_norm) LIKE 'youre on an %' AND p.best_author LIKE '%Posey%')

ORDER BY 1
