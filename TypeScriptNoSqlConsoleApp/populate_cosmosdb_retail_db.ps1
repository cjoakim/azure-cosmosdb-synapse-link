
# PowerShell script to stream documents to Cosmos DB so as to
# generate Change Feed events for an Azure Function.
#
# Chris Joakim, Microsoft, 2023

tsc

node .\dist\index.js populateSalesContainer retail sales --new-ids --sleep-ms:10 --xnoload
