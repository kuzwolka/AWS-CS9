from elasticsearch import Elasticsearch

client = Elasticsearch(
    "http://localhost:9200"   # endpoint
)

doc = {
        "size": 1,
        "query": {
            "term": {
                "OriginCityName": "Seoul"
                }
            }
        }

res = client.search(
        index = 'kibana_sample_data_flights',
        body = doc)

print(res)
