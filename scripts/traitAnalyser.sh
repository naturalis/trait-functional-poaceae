#Shell script to collect all available traits measured from all children of any
#lineage present in the eol.org database.

#This script requires a file named 'eol.token' to be present and contain your
#EoL authorization token. You can also replace '$(cat eol_token.txt)' in line
#12 with your token, but this is not adviced since the token functions similar
#to a password.


#Page ID of desired group
#Poales page ID: 4075
#Poaceae page ID: 8223
PAGEID=4075
#EoL.org authorization token.
EOLTOKEN=$(cat eol.token)


#Query to fetch all children of an ancestor with specified page_id, and collect
#their traits. Each trait is counted per species, and a '1' is put for the
#number of species. Then, each trait and species are summed.

#This query returns three columns. The first column contains the name of a
#trait, the second column shows the total number of occurances. The third
#column shows the number of species that have measurements for this trait.

#The third column was added because some species have multiple measurements
#for one trait.
QUERY="MATCH (child:Page)-[:parent*]->(:Page {page_id: $PAGEID}),
       (child)-[:trait]->(:Trait)-[:predicate]->(pred:Term)
       //WHERE child.canonical STARTS WITH 'Triticum aestivum'

       WITH child, pred, count(pred.name) AS traits, 1 AS species
       RETURN pred.name AS trait, SUM(traits) AS total_occurance,
              SUM(species) AS unique_occurance, pred.uri AS uri,
              pred.definition AS definition, pred.comment AS comment
       ORDER BY total_occurance DESC
       //LIMIT 100;"

#Use cURL to get the data from the EoL database in CSV format.
#-H gives a header containing authorization token.
#-d passes parameters.
curl https://eol.org/service/cypher \
  -H "Authorization: JWT $EOLTOKEN" \
  -d "query=$QUERY&format=csv"
