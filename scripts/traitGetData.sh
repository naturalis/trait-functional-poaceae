#Page ID of desired group.
#Poales page ID: 4075
#Poaceae page ID: 8223
PAGEID=8223
#Trait URI in the EoL database.
TRAIT='http://top-thesaurus.org/annotationInfo?viz=1\u0026\u0026trait=Seed_dry_mass'

#EoL.org authorization token.
EOLTOKEN=$(cat eol.token)


#Query to fetch all children of an ancestor with specified page_id, and collect
#all measurements they have for the trait Seed Dry Mass.

#This query returns four columns. The first column contains the page ID
#for an organism. The second column contains the scientific name.
#The third column stores the name of the trait collected.
#The fourth column has the trait measurement made for that species.
#The fifth column contains the unit the measurement is made in.
#The sixth column lists the source of the trait.
QUERY="MATCH (child:Page)-[:parent*]->(ancestor:Page {page_id: $PAGEID}),
       (child)-[:trait]->(trait:Trait)-[:predicate]->(pred:Term {uri: \"$TRAIT\"})
       //WHERE child.canonical STARTS WITH 'Triticum aestivum'
       OPTIONAL MATCH (trait)-[:units_term]->(unit:Term)

       RETURN child.page_id AS id, child.canonical AS organism, pred.name AS trait,
              trait.measurement AS measurement, unit.name AS unit, trait.source AS source
       //LIMIT 100"

#Use cURL to get the data from the EoL database in CSV format.
#-H gives a header containing authorization token.
#-d passes parameters.
curl https://eol.org/service/cypher \
  -H "Authorization: JWT $EOLTOKEN" \
  -d "query=$QUERY&format=csv"