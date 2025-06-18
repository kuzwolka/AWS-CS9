import urllib.request
from xml.etree.ElementTree import fromstring, ElementTree
from elasticsearch import Elasticsearch, helpers

#urllib.request: HTTP 요청을 보내기 위한 표준 라이브러리
#ElementTree: XML 파싱용
#elasticsearch, helpers: Elasticsearch에 데이터 저장을 위한 라이브러리

# 기본 설정으로 Elasticsearch 서버에 연결합니다
es = Elasticsearch(
        "http://localhost:9200"   # endpoint
        )

# 이 리스트에 문서들을 모아서 나중에 한 번에 Elasticsearch로 전송할 예정입니다
docs = []

# 1000개씩 20회 반복 = 총 20,000건
for i in range (1, 21):
  iStart = (i-1)*1000 + 1
  iEnd = i*1000

#공공데이터포털 API 호출
#URL은 서울시 공공와이파이 정보 XML 버전의 openAPI
#호출 결과를 문자열로 받아옴
  url = 'http://openapi.seoul.go.kr:8088/624f746c4f666f743131327a5a75474a/xml/TbPublicWifiInfo/'+str(iStart)+'/'+str(iEnd)+'/'
  response = urllib.request.urlopen(url)
  xml_str = response.read().decode('utf-8')

#문자열(XML)을 트리 구조로 파싱해서 루트 노드를 가져옵니다. 
  tree = ElementTree(fromstring(xml_str))
  root = tree.getroot()

  for row in root.iter("row"):
    gu_nm = row.find('X_SWIFI_WRDOFC').text
    place_nm = row.find('X_SWIFI_MAIN_NM').text
    place_y = float(row.find('LAT').text)
    place_x = float(row.find('LNT').text)
    doc = {
      "_index": "seoul_wifi2",
      "_source": {
        "gu_nm": gu_nm,
        "place_nm": place_nm,
        "instl_xy": {
          "lat": place_y,
          "lon": place_x
        }
      }
    }
    docs.append(doc)
  print("END", iStart, "~", iEnd)

res = helpers.bulk(es, docs)
print("END")
