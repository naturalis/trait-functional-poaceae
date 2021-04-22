#Poales page ID: 4075
#Poaceae page ID: 8223

PAGEID=4075
QUERY='MATCH (children:Page)-[:parent*]->(ancestor:Page {page_id: '$PAGEID'}),
       (children)-[:trait]->(trait:Trait)-[:predicate]->(pred:Term)
       //WHERE children.canonical STARTS WITH "Triticum aestivum"
       RETURN children.canonical, pred.name
       //LIMIT 100;'

curl https://eol.org/service/cypher \
  -H "Authorization: JWT $(cat eol_token.txt)" \
  -d "query=$QUERY"

