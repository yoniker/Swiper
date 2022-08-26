import psycopg2
from sqlalchemy import create_engine
import pandas as pd
import numpy as np
import pickle
import json
engine = create_engine('postgresql://yoni:dor@localhost:5432/celebs')
engine.connect()
table_df = pd.read_sql_table(
    'active_celebs_mobile',
    con=engine
)
list_celebs = table_df.to_dict('records')
with open('celebs.json','w') as f:
    json.dump(list_celebs,f)

