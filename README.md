# Preschoolers Resource Allocation — SQL & Python Deep-Dive Analysis

## Project overview
This project performs a senior-analyst style exploratory and business-oriented analysis of the preschooler resource-allocation dataset.
**Dataset:** `Preschoolers-resource-allocations new.csv`  
**Records:** 42 children  
**Columns:** 42  
**Analysis stack:** Python, pandas, NumPy, SciPy, Matplotlib, SQLite/SQL

## Important: the column names appear to use domain-specific abbreviations (for example, `GS`, `LS`, `ES`, `AGS_*`, `B/U/cup`). The analysis preserves those labels rather than inventing meanings that are not documented in the source data.


## 1. Business / analytical objectives

1. Establish data quality and structure through an initial EDA.
2. Profile the preschooler population by age and gender.
3. Quantify the distribution of the main outcome measures.
4. Compare outcomes by gender.
5. Assess whether task/order sequencing is associated with outcome differences.
6. Examine relationships among age and outcome measures.
7. Identify the most frequently observed task/resource components.
8. Produce decision-support insights and recommendations for future resource allocation / experiment design.

## 2. Data preparation

The source contains decimal values represented with commas in several columns. These were converted to numeric values safely.

Other cleaning steps:
- Trimmed whitespace from column names.
- Standardized gender values to lowercase.
- Checked missing values.
- Checked duplicate records.
- Preserved source column names and domain abbreviations.
- Loaded the cleaned dataset into SQLite for SQL analysis.

## 3. EDA findings

### Dataset quality
- Rows: **42**
- Columns: **42**
- Duplicate rows: **0**
- Missing cells: **0**
- Age range: **6.08–6.93**
- Mean age: **6.43**

### Population
Gender is balanced after whitespace normalization:
- Boys: **21**
- Girls: **21**

### Average outcome measures
LS                 4.298
ES                 4.286
GS                 3.214
AGS_one_token      0.321
AGS_three_token    0.258
AGS_two_token      0.256

The highest average outcome measure is **LS (4.298)**, while the lowest is **AGS_two_token (0.256)**. Because the metrics may use different scales/constructs, this ranking should be interpreted as descriptive rather than as proof that one construct is universally better.

## 4. Business-level findings

### A. Sequencing / order effect
Average `GS` varies materially across `order_DT`:
order_DT
1    2.071
2    3.800
3    3.769

Average `LS` varies across `Order_LT`:
Order_LT
1    4.000
2    4.885
3    4.067

Average `ES` varies across `Order_ET`:
Order_ET
1    4.250
2    4.429
3    4.179

The experiment/order variables are relatively well balanced in this sample, but the observed differences should not automatically be interpreted as causal effects. Formal ANOVA results are included in the analysis output.

### B. Outcome relationships
The strongest correlation with `GS` among the other measured outcomes is **AGS_two_token (r = 0.73)**.

This indicates that children with higher `GS` values also tend to have higher `{top_corr}` values in this sample. Correlation is associative and should not be interpreted as causation.

### C. Resource/task component utilization
The analysis ranks the `One*`, `Two*`, and `Three*` components by total observed count. See:
- `visualizations/09_resource_component_totals.png`
- `analysis_queries.sql`

These totals are useful for identifying which components are most frequently observed and therefore where measurement or resource-planning attention may be concentrated.


## 5. Statistical analysis

The Python analysis includes:
- Welch independent-samples t-tests for boy vs girl outcome differences.
- One-way ANOVA for:
  - `order_DT` → `GS`
  - `Order_LT` → `LS`
  - `Order_ET` → `ES`
- Pearson correlations among age and outcome variables.

Because the dataset contains only **42** observations, statistical significance should be treated cautiously. Effect sizes, confidence intervals, and replication on a larger sample would strengthen conclusions.


## 6. SQL analysis

`analysis_queries.sql` contains reusable queries for:
- Dataset profiling
- Gender distribution
- Outcome summaries
- Gender comparisons
- Global-task order analysis
- Language-task order analysis
- Executive-task order analysis
- Highest/lowest GS observations
- Resource/task component totals

The SQLite database `preschoolers_analysis.sqlite` contains the cleaned analysis table `preschoolers`.

## 7. Visualizations

The `visualizations/` folder contains:

1. `01_gender_distribution.png`
2. `02_age_distribution.png`
3. `03_average_outcomes.png`
4. `04_outcomes_by_gender.png`
5. `05_GS_by_global_order.png`
6. `06_LS_by_language_order.png`
7. `07_ES_by_executive_order.png`
8. `08_correlation_matrix.png`
9. `09_resource_component_totals.png`
10. `10_GS_vs_LS.png`

## 8. Recommended business actions

1. **Review sequencing:** Compare task orders in future experiments because the current sample shows visible differences between order groups.
2. **Avoid causal overreach:** Treat order differences as signals for follow-up experimentation rather than proof of a treatment effect.
3. **Prioritize measurement quality:** The most frequently observed task/resource components should receive strong data-quality checks because errors there can have a larger impact on reporting.
4. **Use outcome relationships:** The relatively strong association between `GS` and `AGS_two_token` can help identify complementary measures, but should be validated with domain expertise.
5. **Increase sample size:** Replicate the experiment with a larger sample and predefine primary outcomes before testing.
6. **Add documented metadata:** Maintain a data dictionary explaining each abbreviation and scale so that future analysts can make stronger business interpretations.

## 9. Conclusion

The dataset is clean enough for structured exploratory analysis after correcting decimal formatting and categorical whitespace. The sample is balanced by gender and the three major ordering variables are reasonably distributed.

The most important analytical signal is the relationship between **GS and AGS_two_token (r = 0.73)**, along with meaningful differences in outcome averages across task-order groups. These findings make task sequencing and cross-outcome relationships useful areas for further investigation.

However, with only **42 children**, the correct business conclusion is **not** that a particular sequence or demographic causes better performance. The current analysis should be treated as a hypothesis-generation and resource-planning exercise. A larger, controlled follow-up study with a documented data dictionary and pre-specified primary outcomes would provide stronger evidence for operational decisions.
