# System name

DataPlatform

# Reference
flyway: 

https://flywaydb.org/documentation/concepts/migrations

airflow：

https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html#docker-compose-yaml

https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html?highlight=docker

postgres:

https://www.postgresql.org/docs/14/index.html

metabase:

https://www.metabase.com/learn/getting-started/getting-started

## Development

### Requirements

- docker
- colima
- docker-compose
- postgres
- flyway
- airflow
- metabase

### Run the app

cd project folder, then use:

```shell
docker-compose up -d
```

### Maybe Use Commands
```shell
#
colima start -m 10 --cpu 8 --mount /Volumes/WCode/DataPlatform/:w # 替换成自己的路径

# 清除容器和镜像
docker-compose down --volumes --rmi all

# 
docker exec -it  server_name  bash
```



