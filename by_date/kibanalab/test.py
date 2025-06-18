from elasticsearch import Elasticsearch

client = Elasticsearch(
    "http://localhost:9200"   # endpoint
)

doc={"name": "gildong", "age": "25"}
res = client.index(index='gildong_test', body=doc)
print(res)
client.info()
