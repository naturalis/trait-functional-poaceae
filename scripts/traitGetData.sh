#Page ID of desired group.
#Poales page ID: 4075
#Poaceae page ID: 8223
PAGEID=4075
#Trait URI in the EoL database.
TRAIT='http://top-thesaurus.org/annotationInfo?viz=1\u0026\u0026trait=Seed_dry_mass'
#EoL.org authorization token.
EOLTOKEN=$(cat eol.token)



QUERY="MATCH (child:Page)-[:parent*]->(ancestor:Page {page_id: $PAGEID}),
       (child)-[:trait]->(trait:Trait)-[:predicate]->(pred:Term {uri: \"$TRAIT\"})
       //WHERE child.canonical STARTS WITH 'Triticum aestivum'
       OPTIONAL MATCH (trait)-[:units_term]->(unit:Term)

       RETURN child.canonical, pred.name, trait.measurement, unit.name
       //LIMIT 100"

#Use cURL to get the data from the EoL database in CSV format.
#-H gives a header containing authorization token.
#-d passes parameters.
curl https://eol.org/service/cypher \
  -H "Authorization: JWT $EOLTOKEN" \
  -d "query=$QUERY&format=csv"