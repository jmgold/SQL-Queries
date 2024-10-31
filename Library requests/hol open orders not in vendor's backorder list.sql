/*
Jeremy Goldstein
Minuteman Library Network

Find open orders associated with Ingram that do not seem to be included in 
the 'all open items' list on iPage.
Use to find records to batch cancel
*/

SELECT
rm.record_type_code||rm.record_num||'a'
--,o.*

FROM
sierra_view.order_record o
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.varfield v
ON
o.id = v.record_id AND v.varfield_type_code = 'b'
AND LENGTH(SPLIT_PART(v.field_content,'|',1)) = 13

WHERE
o.vendor_record_code ~ '^ing'
AND o.order_status_code = 'o'
AND o.accounting_unit_code_num = '15'
--isbn and order date from Ingram's open order list
AND SPLIT_PART(v.field_content,'|',1)||TO_CHAR(rm.creation_date_gmt,'yyyy-mm-dd') NOT IN
(
'97800086401872024-10-21',
'97800086401872024-10-21',
'97800086470562024-10-21',
'97800086470562024-10-21',
'97800632762152024-10-21',
'97800632935952024-10-21',
'97800632983782024-10-21',
'97800633453002024-10-21',
'97800633817592024-10-21',
'97800633817592024-10-21',
'97800634458192024-10-21',
'97800634458192024-10-21',
'97803165700082024-10-21',
'97803165700082024-10-21',
'97803855476422024-10-21',
'97803855476422024-10-21',
'97805933328632024-10-21',
'97805933328632024-10-21',
'97805934192052024-10-21',
'97805934976922024-10-21',
'97805934976922024-10-21',
'97805934986752024-10-21',
'97805934986752024-10-21',
'97805935447612024-10-21',
'97805935447612024-10-21',
'97805935481892024-10-21',
'97805935481892024-10-21',
'97805936393682024-10-21',
'97805936393682024-10-21',
'97805937184072024-10-21',
'97805937184072024-10-21',
'97805938034862024-10-21',
'97805938034862024-10-21',
'97805938036152024-10-21',
'97805938036152024-10-21',
'97805938314342024-10-21',
'97805938314342024-10-21',
'97805938341692024-10-21',
'97805938510502024-10-21',
'97805938510502024-10-21',
'97807783079832024-10-21',
'97807783079832024-10-21',
'97807783696082024-10-21',
'97807783696082024-10-21',
'97808021636392024-10-21',
'97812502807562024-10-21',
'97812502807562024-10-21',
'97812503284342024-10-21',
'97812503284342024-10-21',
'97812503482722024-10-21',
'97812503482722024-10-21',
'97812503707922024-10-21',
'97812503707922024-10-21',
'97812508858212024-10-21',
'97812508858212024-10-21',
'97813354025302024-10-21',
'97814483134952024-10-21',
'97814483134952024-10-21',
'97815387429832024-10-21',
'97815387429832024-10-21',
'97815387563552024-10-21',
'97815387563552024-10-21',
'97815387705662024-10-21',
'97815387705662024-10-21',
'97816625151492024-10-21',
'97816625151492024-10-21',
'97816625151632024-10-21',
'97816680148822024-10-21',
'97816680148822024-10-21',
'97816680827992024-10-21',
'97816680827992024-10-21',
'97819848058812024-10-21',
'97819848793252024-10-21',
'97819848793252024-10-21',
'97855529040682024-10-21',
'97803165692312024-10-21',
'97807112925052024-10-21',
'97807440737202024-10-21',
'97807440808032024-10-21',
'97812502887382024-10-21',
'97812503383652024-10-21',
'97812508599902024-10-21',
'97813942815722024-10-21',
'97813942915402024-10-21',
'97815460070432024-10-21',
'97815515295542024-10-21',
'97816444530252024-10-21',
'97816680556872024-10-21',
'97817891495792024-10-21',
'97819573639122024-10-21',
'97819821429952024-10-21',
'97819848631642024-10-21',
'97800633817592024-10-16',
'97800634458192024-10-16',
'97803165700082024-10-16',
'97803855476422024-10-16',
'97805933328632024-10-16',
'97805934986752024-10-16',
'97805935447612024-10-16',
'97805935481892024-10-16',
'97805938034862024-10-16',
'97805938510502024-10-16',
'97812503284342024-10-16',
'97812503377882024-10-16',
'97812508987082024-10-16',
'97815387264192024-10-16',
'97815387429832024-10-16',
'97815387563552024-10-16',
'97816625151492024-10-16',
'97816680827992024-10-16',
'97855529040682024-10-16',
'97800634104422024-09-09',
'97800634106262024-09-09',
'97803165808092024-09-09',
'97805939153702024-09-09',
'97814205136392024-09-09',
'97814205146122024-09-09',
'97814205147282024-09-09',
'97814205157702024-09-09',
'97814205164872024-09-09',
'97814205175142024-09-09',
'97814205175212024-09-09',
'97814205175452024-09-09',
'97814205180922024-09-09',
'97814205183752024-09-09',
'97814205183822024-09-09',
'97814205186892024-09-09',
'97815387703442024-09-09',
'97855529040682024-09-09',
'97982170139132024-09-09',
'97982170139372024-09-09',
'97982170140192024-09-09',
'97982170143162024-09-09',
'97988916428502024-09-09',
'97988916431162024-09-09',
'97800632194342024-08-21',
'97800632220832024-08-21',
'97800633550642024-08-21',
'97800633580342024-08-21',
'97800633911472024-08-21',
'97800633960122024-08-21',
'97803164935742024-08-21',
'97803165699722024-08-21',
'97803746165952024-08-21',
'97805255357682024-08-21',
'97805934701522024-08-21',
'97805934756902024-08-21',
'97805934986442024-08-21',
'97805934993992024-08-21',
'97805935370842024-08-21',
'97805936560752024-08-21',
'97805937199302024-08-21',
'97805937300892024-08-21',
'97805938168512024-08-21',
'97807783105942024-08-21',
'97807783873122024-08-21',
'97808021638062024-08-21',
'97812503191802024-08-21',
'97812503197842024-08-21',
'97812503377882024-08-21',
'97812503575952024-08-21',
'97812508755632024-08-21',
'97812509098862024-08-21',
'97813240957292024-08-21',
'97813350063942024-08-21',
'97814197766492024-08-21',
'97814197772332024-08-21',
'97814967494822024-08-21',
'97814967500752024-08-21',
'97814967519422024-08-21',
'97815387110192024-08-21',
'97815387260202024-08-21',
'97815387663472024-08-21',
'97816391092102024-08-21',
'97816391092342024-08-21',
'97816391092652024-08-21',
'97816400967142024-08-21',
'97816407862642024-08-21',
'97816412961512024-08-21',
'97816412968612024-08-21',
'97816456609892024-08-21',
'97816680261682024-08-21',
'97816680332102024-08-21',
'97816680465482024-08-21',
'97816680495942024-08-21',
'97816680581452024-08-21',
'97816680762172024-08-21',
'97816680824302024-08-21',
'97818033699762024-08-21',
'97855529040682024-08-21',
'97803068336632024-08-21',
'97807112952542024-08-21',
'97808070073722024-08-21',
'97814002495272024-08-21',
'97816393676652024-08-21',
'97816399330132024-08-21',
'97800632194342024-08-21',
'97803164036892024-08-21',
'97805934742732024-08-21',
'97805934976922024-08-21',
'97805936384152024-08-21',
'97805938036152024-08-21',
'97807783079832024-08-21',
'97807783684272024-08-21',
'97812502807562024-08-21',
'97812503707922024-08-21',
'97815387705662024-08-21',
'97816680148822024-08-21',
'97816680261682024-08-21',
'97819848793252024-08-21',
'97800623344972024-07-12',
'97800632598672024-07-12',
'97800633435352024-07-12',
'97800633797322024-07-12',
'97800633965242024-07-12',
'97800634111422024-07-12',
'97803164026822024-07-12',
'97803164738592024-07-12',
'97803165637962024-07-12',
'97805933316062024-07-12',
'97805934985832024-07-12',
'97805935489812024-07-12',
'97805935953292024-07-12',
'97805937017682024-07-12',
'97805937161372024-07-12',
'97805937164892024-07-12',
'97805937179742024-07-12',
'97805937188342024-07-12',
'97805937253372024-07-12',
'97805937258012024-07-12',
'97805938334902024-07-12',
'97805938361182024-07-12',
'97805939775692024-07-12',
'97812502887762024-07-12',
'97812503281372024-07-12',
'97812503366752024-07-12',
'97812508879172024-07-12',
'97812508987082024-07-12',
'97813359293582024-07-12',
'97814967459722024-07-12',
'97815387219022024-07-12',
'97815387579012024-07-12',
'97815387670302024-07-12',
'97815387703822024-07-12',
'97816680031382024-07-12',
'97816680158342024-07-12',
'97816680214462024-07-12',
'97855529040682024-07-12',
'97800632657072024-07-12',
'97803855504442024-07-12',
'97805255214402024-07-12',
'97805256197962024-07-12',
'97805933170992024-07-12',
'97805936551152024-07-12',
'97805936551152024-07-12',
'97812503703342024-07-12',
'97812509031672024-07-12',
'97814205170192024-07-12',
'97800632598672024-07-12',
'97800633965242024-07-12',
'97800634111422024-07-12',
'97803164026822024-07-12',
'97803165637962024-07-12',
'97805255214402024-07-12',
'97805933316062024-07-12',
'97805934985832024-07-12',
'97805936551152024-07-12',
'97805937017682024-07-12',
'97805937161372024-07-12',
'97805937164892024-07-12',
'97805937179742024-07-12',
'97805937188342024-07-12',
'97805937253372024-07-12',
'97805937258012024-07-12',
'97805939775692024-07-12',
'97812502887762024-07-12',
'97812503281372024-07-12',
'97815387219022024-07-12',
'97815387579012024-07-12',
'97815387670302024-07-12',
'97815387703822024-07-12',
'97816680031382024-07-12',
'97816680158342024-07-12',
'97815248871862024-05-08',
'97813990413242024-04-24'
)