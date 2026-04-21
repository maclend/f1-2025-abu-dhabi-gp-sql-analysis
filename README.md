# Formula 1 2025 Abu Dhabi Grand Prix analysis using SQL

## Data Description
The dataset consists of three CSV files from Kaggle, with minor changes (column removal or renaming):  
- **lap_times.csv** - lap-by-lap performance data  
- **qualifying_results.csv** - qualifying session results (Q1, Q2, Q3)  
- **race_results.csv** - final race standings with detailed race information 

Dataset source:  [F1 2025 Abu Dhabi GP Dataset](https://www.kaggle.com/datasets/umerhaddii/formula-1-24-rounds-complete-data-all-gps-2025)



## Data Processing
Raw CSV files were loaded into staging tables and transformed into analytical tables using SQL.    

Transformations included:   
- Converting time formats into INTERVAL type  
- Handling missing values with NULLIF  
- Cleaning inconsistent data formats  
- Casting numeric values to correct data types  


