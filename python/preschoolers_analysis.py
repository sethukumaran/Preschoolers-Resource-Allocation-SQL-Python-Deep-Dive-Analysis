"""
Preschoolers Resource Allocation Analysis
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

FILE = "preschoolers-resource-allocations new.csv"
df = pd.read_csv(FILE)
df.columns = [c.strip() for c in df.columns]
df["Gender"] = df["Gender"].astype(str).str.strip().str.lower()

for c in df.columns:
    if c != "Gender" and df[c].dtype == "object":
        s = df[c].astype(str).str.strip().str.replace(",", ".", regex=False)
        n = pd.to_numeric(s, errors="coerce")
        if n.notna().mean() >= 0.80:
            df[c] = n

# EDA
print("Shape:", df.shape)
print("\nData types:\n", df.dtypes)
print("\nMissing values:\n", df.isna().sum())
print("\nDuplicate rows:", df.duplicated().sum())
print("\nNumeric summary:\n", df.describe().T)

score_cols = ["GS","AGS_one_token","AGS_two_token","AGS_three_token","LS","ES"]
print("\nOutcome means:\n", df[score_cols].mean().sort_values(ascending=False))
print("\nGender comparison:\n", df.groupby("Gender")[["age"]+score_cols].mean().round(3))
print("\nGlobal-task order:\n", df.groupby("order_DT")[score_cols[:4]].mean().round(3))
print("\nLanguage order:\n", df.groupby("Order_LT")[["LS","GS"]].mean().round(3))
print("\nExecutive order:\n", df.groupby("Order_ET")[["ES","GS"]].mean().round(3))
print("\nCorrelations:\n", df[["age"]+score_cols].corr().round(2))

# Statistical checks
boys, girls = df[df.Gender=="boy"], df[df.Gender=="girl"]
for metric in score_cols:
    t,p = stats.ttest_ind(boys[metric], girls[metric], equal_var=False)
    print(f"Gender t-test {metric}: t={t:.3f}, p={p:.4f}")

for order_col, metric in [("order_DT","GS"),("Order_LT","LS"),("Order_ET","ES")]:
    groups=[g[metric].values for _,g in df.groupby(order_col)]
    f,p=stats.f_oneway(*groups)
    print(f"ANOVA {order_col} -> {metric}: F={f:.3f}, p={p:.4f}")
