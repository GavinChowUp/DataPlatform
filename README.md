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

### Run the app

before init ,if you run before, should delete containers and volumes. ,cd project folder, then use:

```shell
docker-compose up -d
```

- find the airflow container id , if start failed ,then restart it.
- use `docker logs -f <airflow_container_id>` tail the log
- web: localhost:8080
- return log: you will find the log :
   ```log
    standalone | Airflow is ready
    standalone | Login with username: admin  password: qRENYbzGqwdAgtpr
   ```
- use this login
- use `create_connection.sql` create pg connection.
- run `first_pipeline.py` in airflow
- Active daily dags and run  dags `Oltp_To_Ods_DB`

### Maybe Use Commands

```shell
#
colima start -m 10 --cpu 8 --mount /Volumes/Work/Code/DataPlatform/:w # 替换成自己的路径

# 清除容器和镜像
docker-compose down --volumes --rmi all

# 只清除容器
docker rm -f $(docker ps -aq)

# 清除volume
docker volume rm $(docker volume ls)
# 
docker exec -it  server_name  bash
```

### 作业中发现题目的错误以及假设

+ unitprice * orderqty - 产品表中的 StandardCost = 利润，不是应该是unitprice * orderqty - 产品表中的 StandardCost* orderqty= 利润

+ unitprice * orderqty - 产品表中的 StandardCost = 利润 此公式忽略了折扣

+ 按照给的数据计算的subtotal，每个订单的产品总价数据对不上

+ customer - customer_address - address 推断用户属于那个城市，customer_address 表中一个用户可能有多个地址，比如：main office,home等类型地址，根据数据判断，数据最全的是main office 地址，所以按照main office 计算;

+ 给的所有数据中，创建时间：orderdate、更新时间：modifieddate，是一样的，所以题目要求应该笔误了，发货时间应该取shipdate

### 作业要求

<aside>
💡 1. 搭建调度服务和数据库，具体的技术选型不做限制

2. 根据excel中的数据进行建模和ETL开发，完成如下报表

3. 报表

1. 每月不同城市客户的销售额（totalDue），利润额，销售增长率
2. 每天（怀疑是每周）卖出产品利润最高的top 10
3. 当前所有订单从创建到发货时间跨度长的top 10

如下是报表的详细描述:

1. 每月 -> orderdate

不同城市客户

销售额totalDue-> customer - customer_address - address的销售额 -> total_due

利润额 -> 根据订单表中的 unitprice * orderqty - 产品表中的 StandardCost

销售增长率 -> total_due对比上一个月的增长率

2. 每周 -> orderdate （周一 ~ 周天）

卖出产品名称 -> product

利润 -> 根据订单表中的 unitprice * orderqty - 产品表中的 StandardCost最高的top 10

3. 当前所有订单从创建到发货时间 ->

状态（*->5）时

创建时间：orderdate、更新时间：modifieddate

跨度时长的订单top 10

状态5是发货状态，更新时间就是发货时间？

作业要求

尽可能满足课件中的内容，如前期访谈、ETL编排、数据建模、ETL幂等性、安全等考虑。

注意：关于业务和需求问题，可以找xiaoqiang和zhangyuan进行访谈。

</aside>