# UPOST-SERVICE-03
모바일우편함 Service03 서버로 주로 elastic search와 kibana가 설치되어 동작하는 서버이다.
주로 elastic search 관련 설정을 위주로 작성한다.

# Pre-requisite

Elastic Search NoSQL 버전 체크
```
# curl "localhost:9200"
{
  "name" : "node-1",
  "cluster_name" : "emailbox",
  "cluster_uuid" : "qeu2VRQ7R6yfuzavcDlO5A",
  "version" : {
    "number" : "6.5.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "816e6f6",
    "build_date" : "2018-11-09T18:58:36.352602Z",
    "build_snapshot" : false,
    "lucene_version" : "7.5.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

# elastic search - Operation with docker
to operation with the elasticsearch docker
```
$ docker run -p 9200:9200 -p 9300:9300 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/service03/config:/usr/share/elasticsearch/config -v /Users/alwayswinner/Develops/upost-network/service03/node01:/data/elasticsearch -v /Users/alwayswinner/Develops/upost-network/service03/log01:/var/log/elasticsearch -e KEYSTORE_PASSWORD=admin -d docker.elastic.co/elasticsearch/elasticsearch:6.5.0

$ docker run -p 9200:9200 -p 9300:9300 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/service03/config:/usr/share/elasticsearch/config -v /Users/alwayswinner/Develops/upost-network/service03/node01:/data/elasticsearch -v /Users/alwayswinner/Develops/upost-network/service03/log01:/var/log/elasticsearch -d docker.elastic.co/elasticsearch/elasticsearch:6.5.0

$ docker run -p 9200:9200 -p 9300:9300 --restart unless-stopped --net=bridge -v /home/blab/config:/usr/share/elasticsearch/config -v /home/blab/node01:/data/elasticsearch -v /home/blab/log01:/var/log/elasticsearch -d docker.elastic.co/elasticsearch/elasticsearch:6.5.0

$ docker run -p 9200:9200 -p 9300:9300 --restart unless-stopped --net=bridge -v /home/blab/config:/usr/share/elasticsearch/config -v /home/blab/node01:/data/elasticsearch -v /home/blab/log01:/var/log/elasticsearch --privileged docker.elastic.co/elasticsearch/elasticsearch:6.5.0

$ docker run -p 9200:9200 -p 9300:9300 --net=bridge -it docker.elastic.co/elasticsearch/elasticsearch:6.5.0 bash

$ docker run -p 9200:9200 -p 9300:9300 --net=bridge --privileged docker.elastic.co/elasticsearch/elasticsearch:6.5.0

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```

# Operations
## add the pipline
기존 운영네트워크에서 파이프라인을 가지고 와서 추가해야 한다. 이 부분은 자동을 처리하기 어려워서 일단 수동으로 설치하는 것으로 한다. 그러나 추후 logstash와 연동하면 자동으로 추가할 수 있을 것으로 생각됨. (참고 : https://stackoverflow.com/questions/52732254/how-to-pre-configure-an-elasticsearch-pipeline-in-docker-image )

### 1.기본적인 파이프라인 확인
```
$ curl http://localhost:9200/_ingest/pipeline/
    {
        "xpack_monitoring_2": {
            "description": "This pipeline upgrades documents from the older version of the Monitoring API to the newer version (6) by fixing breaking changes in those older documents before they are indexed from the older version (2).",
            "version": 6050099,
            "processors": [{
                "script": {
                    "source": "boolean legacyIndex = ctx._index == '.monitoring-data-2';if (legacyIndex || ctx._index.startsWith('.monitoring-es-2')) {if (ctx._type == 'cluster_info') {ctx._type = 'cluster_stats';ctx._id = null;} else if (legacyIndex || ctx._type == 'cluster_stats' || ctx._type == 'node') {String index = ctx._index;Object clusterUuid = ctx.cluster_uuid;Object timestamp = ctx.timestamp;ctx.clear();ctx._id = 'xpack_monitoring_2_drop_bucket';ctx._index = index;ctx._type = 'legacy_data';ctx.timestamp = timestamp;ctx.cluster_uuid = clusterUuid;}if (legacyIndex) {ctx._index = '<.monitoring-es-6-{now}>';}}"
                }
            }, {
                "rename": {
                    "field": "_type",
                    "target_field": "type"
                }
            }, {
                "set": {
                    "field": "_type",
                    "value": "doc"
                }
            }, {
                "gsub": {
                    "field": "_index",
                    "pattern": "(.monitoring-\\w+-)2(-.+)",
                    "replacement": "$16$2"
                }
            }]
        },
        "xpack_monitoring_6": {
            "description": "This is a placeholder pipeline for Monitoring API version 6 so that future versions may fix breaking changes.",
            "version": 6050099,
            "processors": []
        }
    }

```

### 2.실제 운영서버에서 파이프라인 확인을 통해 set_emb_default 
```
# curl http://localhost:9200/_ingest/pipeline/
    {
        "xpack_monitoring_2": {
            "description": "This pipeline upgrades documents from the older version of the Monitoring API to the newer version (6) by fixing breaking changes in those older documents before they are indexed from the older version (2).",
            "version": 6050099,
            "processors": [{
                "script": {
                    "source": "boolean legacyIndex = ctx._index == '.monitoring-data-2';if (legacyIndex || ctx._index.startsWith('.monitoring-es-2')) {if (ctx._type == 'cluster_info') {ctx._type = 'cluster_stats';ctx._id = null;} else if (legacyIndex || ctx._type == 'cluster_stats' || ctx._type == 'node') {String index = ctx._index;Object clusterUuid = ctx.cluster_uuid;Object timestamp = ctx.timestamp;ctx.clear();ctx._id = 'xpack_monitoring_2_drop_bucket';ctx._index = index;ctx._type = 'legacy_data';ctx.timestamp = timestamp;ctx.cluster_uuid = clusterUuid;}if (legacyIndex) {ctx._index = '<.monitoring-es-6-{now}>';}}"
                }
            }, {
                "rename": {
                    "field": "_type",
                    "target_field": "type"
                }
            }, {
                "set": {
                    "field": "_type",
                    "value": "doc"
                }
            }, {
                "gsub": {
                    "field": "_index",
                    "pattern": "(.monitoring-\\w+-)2(-.+)",
                    "replacement": "$16$2"
                }
            }]
        },
        "xpack_monitoring_6": {
            "description": "This is a placeholder pipeline for Monitoring API version 6 so that future versions may fix breaking changes.",
            "version": 6050099,
            "processors": []
        },
        "set_emb_default": {
            "description": "Adds a field to a document with the time of ingestion",
            "processors": [{
                "set": {
                    "field": "status.time.@registed",
                    "value": "{{_ingest.timestamp}}"
                }
            }, {
                "set": {
                    "field": "status.result",
                    "value": "0000"
                }
            }, {
                "set": {
                    "field": "status.read",
                    "value": 0
                }
            }, {
                "set": {
                    "field": "status.dispatching",
                    "value": "waiting"
                }
            }]
        }
    }

```

### 3. 개발서버에서 set_emb_default 추가

```
curl -X PUT "localhost:9200/_ingest/pipeline/set_emb_default?pretty" -H 'Content-Type: application/json' -d'
{
    "description": "Adds a field to a document with the time of ingestion",
    "processors": [{
        "set": {
            "field": "status.time.@registed",
            "value": "{{_ingest.timestamp}}"
        }
    }, {
        "set": {
            "field": "status.result",
            "value": "0000"
        }
    }, {
        "set": {
            "field": "status.read",
            "value": 0
        }
    }, {
        "set": {
            "field": "status.dispatching",
            "value": "waiting"
        }
    }]
}
'
```

## 4. cluster setting 추가
아래는 확인을 위한 기능이며 기존 사항과 대비하여 업데이트 한다.
```
# curl "http://localhost:9200/_cluster/settings?pretty"
{
  "persistent" : {
    "xpack" : {
      "monitoring" : {
        "collection" : {
          "enabled" : "true"
        }
      }
    }
  },
  "transient" : { }
}
```

## 5. add index
원래는 서버동작 중 AGENCY가 추가되면 자동적으로 index에 alias를 추가해야 rollover 기능이 가능해진다. 그러나 현재 개발 네트워크의 경우에는 데이터베이스를 스냅샷을 통해 작동하기 떄문에 해당 동작이 되지 않아서 AGENCY만큼 강제로 추가해 주어야 한다. 간단하게나 kibana 툴을 사용하여 진행하면 되고 아니면 curl로 변경하여 업데이트 한다. 아래는 키바나를 사용하는 형태이다. 11001은 Agency에 대한 index이다.
```
PUT /11001-000001 
{
  "aliases": {
    "11001": {}
  }
}



```

## 6. and so on

### 6.1 rollover
elasticsearch rollover
```
curl --user admin:admin -XPOST 'http://localhost:9200/11001/_rollover?pretty' -H "Content-Type: application/json" -d '{"conditions": {"max_age": "350d"}}'
{
  "acknowledged" : false,
  "shards_acknowledged" : false,
  "old_index" : "11001-000011",
  "new_index" : "11001-000012",
  "rolled_over" : false,
  "dry_run" : false,
  "conditions" : {
    "[max_age: 350d]" : false
  }
}
```
### 6.2 status

```
$ curl http://localhost:9200/_nodes/process?pretty
$ curl http://localhost:9200/_nodes/stats?pretty

$ curl 'localhost:9200/_cat/indices?pretty'
$ curl 'localhost:9200/_cat/indices?v'
```

### 6.3 alias

```
$ curl -XPOST 'http://localhost:9200/_aliases?pretty'  -H "Content-Type: application/json" -d'
{
    "actions" : [
        { "remove" : { "index" : "11001", "alias" : "" } }
    ]
}'


# curl -XGET  'localhost:9200/_cat/aliases?v'
alias   index        filter routing.index routing.search
49757   49757-000001 -      -             -
51001   51001-000001 -      -             -
11001   11001-000013 -      -             -
90001   90001-000012 -      -             -
.kibana .kibana_1    -      -             -
11002   11002-000002 -      -             -

# curl -XGET  'localhost:9200/_cat/aliases/11001'
11001 11001-000013 - - -
```
### 6.4 Query

```
$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "10",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.additional.receiver.name": {
                            "query": "마천서울약국(윤광희)",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'


$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "1",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.17",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "status.dispatching": {
                            "query": "ing",
                            "operator": "and"
                        }
                    }
                }

            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "0",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.20",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "status.dispatching": {
                            "query": "ing",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "0",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.20",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "2",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.13",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'


$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "2",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.19",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.dispatching.dm.type": {
                            "query": "registered",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "status.dispatching": {
                            "query": "done",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.template.code": {
                            "query": "00001",
                            "operator": "and"
                        }
                    }
                }           
            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "2",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.18",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "status.dispatching": {
                            "query": "done",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "status.class": {
                            "query": "4",
                            "operator": "and"
                        }
                    }
                },                
                {
                    "match": {
                        "binding.reserved.essential.template.code": {
                            "query": "00001",
                            "operator": "and"
                        }
                    }
                }           
            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "10",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "_id": {
                            "query": "Zne-FXkBe6eBZUV_Rb1Y",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'

$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "10",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.search.request-id": {
                            "query": "60002-201500998382103",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'

$ curl "http://localhost:9200/_alias?pretty"

```


GET /11001-*/_search
{
    "from" : "0",
    "size" : "5",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ]
}

curl -XPOST 'localhost:9200/my_index/_analyze?pretty' -H 'Content-Type: application/json' -d'
{
  "analyzer": "my_custom_analyzer",
  "text": "여러개의 물건들"
}



### 6.5 delete
nosql 데이터 삭제

```
$ curl -XPOST 'http://localhost:9200/11001*/_delete_by_query?pretty'  -H "Content-Type: application/json" -d'
{
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.17",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'
```
확인을 위해
```
$ curl -XGET 'http://localhost:9200/11001*/_search?pretty'  -H "Content-Type: application/json" -d'
{
    "from" : "0",
    "size" : "1",
    "sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
    "query" : {
        "bool": {
            "must": [
                {
                    "match": {
                        "binding.reserved.essential.agency.dept-code": {
                            "query": "60002",
                            "operator": "and"
                        }
                    }
                },
                {
                    "match": {
                        "binding.reserved.essential.search.group-by": {
                            "query": "2021.08.17",
                            "operator": "and"
                        }
                    }
                }
            ]
        }
    }
}'

```



## vm.max_map_count

Elasticsearch uses a mmapfs directory by default to store its indices. The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions.

On Linux, you can increase the limits by running the following command as root:
```
sysctl -w vm.max_map_count=262144
```
To set this value permanently, update the vm.max_map_count setting in /etc/sysctl.conf. To verify after rebooting, run sysctl vm.max_map_count.

The RPM and Debian packages will configure this setting automatically. No further configuration is required.




## ubuntu vm.max_map_count setting
```
1. vi /etc/systemd/system.conf
DefaultLimitNOFILE=65536

2. vi /etc/security/limits.conf

*       soft    nofile  65536
*       hard    nofile  65536
*       soft    nproc   65536
*       hard    nproc   65536
*       soft    memlock unlimited
*       hard    memlock unlimited


3. sudo vi /etc/sysctl.conf
vm.max_map_count=262144
```





GET /11001-*/_search
{
		"size": 100,
		"sort" : [
        {
            "status.time.@registed" : "desc"
        }
    ],
		"query": {
		"bool": {
			"must": [
				{
					"match": {
					  "status.dispatching": {
					    "query": "waiting",
					    "operator": "and"
					  }
					}
				},
				{
					"bool" : {
						"must_not": [
							{
								"match": {
									"status.class": {
									"query": "4",
									"operator": "or"
									}
								}
							},
							{
								"match": {
									"status.class": {
									"query": "4",
									"operator": "or"
									}
								}
							}
						]
					}
				},
				{
					"match": {
					  "binding.reserved.essential.template.code": {
					    "query": "00003",
					    "operator": "and"
					  }
					}          
				},				
				{
					"bool": {
					"should": [
					{
						"range": {
							"binding.reserved.essential.dispatching.@res-time": {
								"lt": "now"
							}
						}
					},
					{
						"bool": {
							"must_not": {
								"exists": {
								"field": "binding.reserved.essential.dispatching.@res-time"
								}
							}
						}
					}
					]
					}
				}
			]
		}
		}
	}
