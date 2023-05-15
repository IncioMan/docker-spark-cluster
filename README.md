```
docker build -t my_jupyter_image .; docker run -p 8888:8888 my_jupyter_image
```

```
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MyApp") \
    .getOrCreate()

from pyspark.sql.functions import *
df = spark.range(2013,2051).withColumnRenamed("id","Year").withColumn("Sea Level",lit(0.0))
df.show(10)
```

  git config --global user.email "alex.incerti@outlook.com"
  git config --global user.name "IncioMan"