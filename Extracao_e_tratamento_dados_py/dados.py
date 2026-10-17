import pandas as pd
from pathlib import Path

# Pasta onde estão os arquivos CSV da Olist (relativa a este arquivo)
PASTA_DADOS = Path(__file__).parent / "dados"

payments = pd.read_csv(PASTA_DADOS / "olist_order_payments_dataset.csv")
print(payments.head())
