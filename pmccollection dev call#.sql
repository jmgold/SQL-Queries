SELECT
CASE
WHEN v.field_content ~ '\|f\[Careers' THEN 'Careers'
WHEN v.field_content ~ '\|fDVD' THEN 'DVD'
WHEN v.field_content ~ '\|f\[Graphic' THEN 'Graphic'
WHEN v.field_content ~ '\|f\[HOT' THEN 'Hot Topics'
WHEN v.field_content ~ '\|f\[Popular' THEN 'Popular Reading'
WHEN v.field_content ~ '\|f\[REF' THEN 'REF'
WHEN v.field_content ~ '\|aA[A-Z 0-9][0-9]' THEN 'A'
WHEN v.field_content ~ '\|aB[A-E 0-9][0-9]' THEN 'B-BE'
WHEN v.field_content ~ '\|aBF[0-9]' THEN 'BF'
WHEN v.field_content ~ '\|aBG[0-9G-Z][0-9]' THEN 'BG-BZ'
WHEN v.field_content ~ '\|aC[A-Z 0-9][0-9]' THEN 'C'
WHEN v.field_content ~ '\|aD[A-Z 0-9][0-9]' THEN 'D'
WHEN v.field_content ~ '\|aE[A-Z 0-9][0-9]' THEN 'E'
WHEN v.field_content ~ '\|aF[A-Z 0-9][0-9]' THEN 'F'
WHEN v.field_content ~ '\|aG[A-Z 0-9][0-9]' THEN 'G'
WHEN v.field_content ~ '\|aH[ 0-9][0-9]' THEN 'H'
WHEN v.field_content ~ '\|aHA[0-9]' THEN 'HA'
WHEN v.field_content ~ '\|aH[B-C][0-9]' THEN 'HB-HC'
WHEN v.field_content ~ '\|aHD[0-9]' THEN 'HD'
WHEN v.field_content ~ '\|aH[E-F][0-9]' THEN 'HE-HF'
WHEN v.field_content ~ '\|aHG[0-9]' THEN 'HG'
WHEN v.field_content ~ '\|aH[H-L][0-9]' THEN 'HH-HL'
WHEN v.field_content ~ '\|aHM[0-9]' THEN 'HM'
WHEN v.field_content ~ '\|aHN[0-9]' THEN 'HN'
WHEN v.field_content ~ '\|aH[O-S][0-9]' THEN 'HO-HS'
WHEN v.field_content ~ '\|aHT[0-9]' THEN 'HT'
WHEN v.field_content ~ '\|aHU[0-9]' THEN 'HU'
WHEN v.field_content ~ '\|aHV[0-9]' THEN 'HV'
WHEN v.field_content ~ '\|aH[W-Z][0-9]' THEN 'HW-HZ'
WHEN v.field_content ~ '\|aI[A-Z 0-9][0-9]' THEN 'I'
WHEN v.field_content ~ '\|aJ[A-Z 0-9][0-9]' THEN 'J'
WHEN v.field_content ~ '\|aK[A-Z 0-9][0-9]' THEN 'K'
WHEN v.field_content ~ '\|aL[A-Z 0-9][0-9]' THEN 'L'
WHEN v.field_content ~ '\|aM[A-Z 0-9][0-9]' THEN 'M'
WHEN v.field_content ~ '\|aN[A-B][0-9]' THEN 'N-NB'
WHEN v.field_content ~ '\|aNC[0-9]' THEN 'NC'
WHEN v.field_content ~ '\|aND[0-9]' THEN 'ND'
WHEN v.field_content ~ '\|aN[E-Z][0-9]' THEN 'NE-NZ'
WHEN v.field_content ~ '\|aO[A-Z 0-9][0-9]' THEN 'O'
WHEN v.field_content ~ '\|aP[A-M][0-9]' THEN 'P-PM'
WHEN v.field_content ~ '\|aPN[0-9]' THEN 'PN'
WHEN v.field_content ~ '\|aP[O-P][0-9]' THEN 'PO-PP'
WHEN v.field_content ~ '\|aPQ[0-9]' THEN 'PQ'
WHEN v.field_content ~ '\|aP[R-Y][0-9]' THEN 'PR-PY'
WHEN v.field_content ~ '\|aPZ[0-9]' THEN 'PZ'
WHEN v.field_content ~ '\|aQ[A-C 0-9][0-9]' THEN 'Q-QC'
WHEN v.field_content ~ '\|aQD[0-9]' THEN 'QD'
WHEN v.field_content ~ '\|aQ[E-G][0-9]' THEN 'QE-QG'
WHEN v.field_content ~ '\|aQH[0-9]' THEN 'QH'
WHEN v.field_content ~ '\|aQ[I-J][0-9]' THEN 'QI-QJ'
WHEN v.field_content ~ '\|aQK[0-9]' THEN 'QK'
WHEN v.field_content ~ '\|aQL[0-9]' THEN 'QL'
WHEN v.field_content ~ '\|aQM[0-9]' THEN 'QM'
WHEN v.field_content ~ '\|aQ[N-O][0-9]' THEN 'QN-QO'
WHEN v.field_content ~ '\|aQP[0-9]' THEN 'QP'
WHEN v.field_content ~ '\|aQQ[0-9]' THEN 'QQ'
WHEN v.field_content ~ '\|aQR[0-9]' THEN 'QR'
WHEN v.field_content ~ '\|aQ[S-Z][0-9]' THEN 'QS-QZ'
WHEN v.field_content ~ '\|aR[A 0-9][0-9]' THEN 'R-RA'
WHEN v.field_content ~ '\|aRB[0-9]' THEN 'RB'
WHEN v.field_content ~ '\|aRC[0-9]' THEN 'RC'
WHEN v.field_content ~ '\|aR[D-F][0-9]' THEN 'RD-RF'
WHEN v.field_content ~ '\|aRG[0-9]' THEN 'RG'
WHEN v.field_content ~ '\|aR[H-I][0-9]' THEN 'RH-RI'
WHEN v.field_content ~ '\|aRJ[0-9]' THEN 'RJ'
WHEN v.field_content ~ '\|aR[K-L][0-9]' THEN 'RK-RL'
WHEN v.field_content ~ '\|aRM[0-9]' THEN 'RM'
WHEN v.field_content ~ '\|aR[N-R][0-9]' THEN 'RN-RR'
WHEN v.field_content ~ '\|aRS[0-9]' THEN 'RS'
WHEN v.field_content ~ '\|aRT[0-9]' THEN 'RT'
WHEN v.field_content ~ '\|aRU[0-9]' THEN 'RU'
WHEN v.field_content ~ '\|aRV[0-9]' THEN 'RV'
WHEN v.field_content ~ '\|aRW[0-9]' THEN 'RW'
WHEN v.field_content ~ '\|aRX[0-9]' THEN 'RX'
WHEN v.field_content ~ '\|aRY[0-9]' THEN 'RY'
WHEN v.field_content ~ '\|aRZ[0-9]' THEN 'RZ'
WHEN v.field_content ~ '\|aS[A-Z 0-9][0-9]' THEN 'S'
WHEN v.field_content ~ '\|aT[A-Q 0-9][0-9]' THEN 'T-TQ'
WHEN v.field_content ~ '\|aTR[0-9]' THEN 'TR'
WHEN v.field_content ~ '\|aT[S-Z 0-9][0-9]' THEN 'TS-TZ'
WHEN v.field_content ~ '\|aU[A-Z 0-9][0-9]' THEN 'U'
WHEN v.field_content ~ '\|aV[A-Z 0-9][0-9]' THEN 'V'
WHEN v.field_content ~ '\|aW[A-Z 0-9][0-9]' THEN 'W'
WHEN v.field_content ~ '\|aX[A-Z 0-9][0-9]' THEN 'X'
WHEN v.field_content ~ '\|aY[A-Z 0-9][0-9]' THEN 'Y'
WHEN v.field_content ~ '\|aZ[A-Z 0-9][0-9]' THEN 'Z'
ELSE 'unknown'
END AS "Call#_Range",
COUNT (i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'),2) AS "AVG_price",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2))/cast(count (i.id) as numeric (12,2)), 2) as turnover,
round(cast(count(i.id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where location_code LIKE 'pmc%'), 6) as relative_item_total,
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'pmc%'), 6) as relative_circ
FROM
sierra_view.item_record as i
JOIN
sierra_view.varfield as v
ON
v.record_id = i.id AND v.varfield_type_code = 'c'
WHERE i.location_code LIKE 'pmc%' and i.item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')
GROUP BY 1
ORDER BY 1;
