#Poales page ID: 4075
#Poaceae page ID: 8223

PAGEID=4075
QUERY='MATCH (child:Page)-[:parent*]->(ancestor:Page {page_id: '$PAGEID'}),
       (child)-[:trait]->(trait:Trait)-[:predicate]->(pred:Term)
       //WHERE child.canonical STARTS WITH "Triticum aestivum"

       WITH child, pred, count(pred.name) AS traits, 1 AS species
       RETURN pred.name AS trait, SUM(traits) AS total_occurance, SUM(species) AS unique_occurance
       ORDER BY total_occurance DESC
       //LIMIT 100;'

curl https://eol.org/service/cypher \
  -H "Authorization: JWT $(cat eol_token.txt)" \
  -d "query=$QUERY&format=csv"

