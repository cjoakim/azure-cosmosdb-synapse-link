
# Display a related sale and line_item.
# Chris Joakim, Microsoft

echo ''
echo 'sales document; doctype = sale:'
cat data/retail/sales1.json | select-string -pattern "sale" | Get-Content -Tail 1 | jq 

echo ''
echo 'related sales document; doctype = line_item:'
cat data/retail/sales1.json | select-string -pattern "line_item" | Get-Content -Tail 1 | jq  

echo 'done'
